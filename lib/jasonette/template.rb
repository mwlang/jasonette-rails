module Jasonette

  class JasonSingleton
    private_class_method :new
    @@instances = []

    def self.fetch context
      if instance = find(context)
        instance
      else
        instance = Jasonette::Template.new(context)
        @@instances << instance
        instance
      end
    end

    def self.find context
      @@instances.select { |instance| instance.context == context }.first
    end

    def self.reset context
      if instance = find(context)
        instances.delete_if { |i| i == instance }
      end
    end

    def self.instances
      @@instances
    end
  end

  class Template < Jasonette::Base
    attr_accessor :layout, :locals

    def self.load context
      JasonSingleton.fetch context
    end

    def jason name=nil, &block
      builder = Jasonette::Jason.new(context, &block)
      set! name || "$jason", builder.attributes!
      JasonSingleton.reset context
      self
    end
    alias build jason

    def has_layout? template_id
      template = get_view_template(template_id)
      layout_path && layout_path != template.virtual_path
    end

    def layout_path
      layout && layout.try(:virtual_path)
    end

    def get_view_template template_id
      ObjectSpace._id2ref(template_id.to_i)
    end

    def new_jason template_id
      new_jason = self.class.new context
      new_jason.set! "_template", "#{template_id}"
      new_jason
    end
  end
end
