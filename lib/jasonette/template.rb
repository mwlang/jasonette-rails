module Jasonette

  class JasonSingleton
    private_class_method :new

    def self.fetch context
      if (defined?(@@instance) && @@instance)
        return @@instance if !context.nil? && (instance.context == context)
        reset
      end
      @@instance = Jasonette::Template.new(context)
    end

    def self.instance
      @@instance
    end

    def self.reset
      @@instance = nil
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

    # def inline! name
    #   partial_source = @context.lookup_context.find_file(name, @context.lookup_context.prefixes, true).source
    #   json = self
    #   source = <<-RUBY
    #     json.jason do
    #       instance_eval(partial_source)
    #     end
    #   RUBY
    #
    #   instance_eval source
    #   self
    # end
    #
    # def inline name
    #   builder = JasonSingleton.fetch(@context)
    #   {name => builder.object_id.to_s}.to_json
    # end
    #
    # def head &block
    #   builder = Jasonette::Jason::Head.new(@context)
    #   builder.with_attributes { instance_eval(&block) }
    #   set! "head", builder.attributes!
    #   self
    # end
    #
    # def template &block
    #   puts '@' * 40, 'template'
    #
    #   builder = Jasonette::Jason::Template.new(@context)
    #   builder.with_attributes { instance_eval(&block) }
    #   set! "template", builder.attributes!
    #   self
    # end
    #
    # def body &block
    #   puts '@' * 40, 'body'
    #
    #   builder = Jasonette::Jason::Body.new(@context)
    #   builder.with_attributes { instance_eval(&block) }
    #   set! "body", builder.attributes!
    #   self
    # end
  end
end
