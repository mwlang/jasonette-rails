module Jasonette
  class JasonSingleton
    private_class_method :new

    def self.fetch context
      return @@instance if defined?(@@instance) && @@instance
      @@instance = Jasonette::Jason.new(context)
    end

    def self.instance
      @@instance
    end

    def self.reset
      @@instance = nil
    end
  end

  module JbuilderExtensions
    def j
      JasonSingleton.fetch(@context)
    end

    def jason &block
      builder = JasonSingleton.fetch(@context)
      builder.with_attributes { instance_eval(&block) }
      _set_value "$jason", builder.attributes!
      JasonSingleton.reset
      self
    end

    def build name, &block
      builder = JasonSingleton.fetch(@context)
      builder.with_attributes { instance_eval(&block) }
      _set_value name, _scope { builder.attributes! }
      self
    end

    # def inline name
    #   builder = JasonSingleton.fetch(@context)
    #   {name => builder.object_id.to_s}.to_json
    # end

    # # TODO : WORKING WITH BLOCK
    # def inline! name
    #   j = JbuilderTemplate.new(@context) do |json|
    #     json.partial! name
    #   end
    #   @attributes.merge! j.attributes!
    #   self
    # end

    def inline! name
      partial_source = @context.lookup_context.find_file(name, @context.lookup_context.prefixes, true).source
      source = <<-RUBY
        json.jason do
          instance_eval(partial_source)
        end
      RUBY
      
      builder = JbuilderTemplate.new(@context) do |json|
        instance_eval(source)
      end
      @attributes.merge! builder.attributes!
      self
    end

    # # TODO : EFFORT
    # def inline! name
    #   # ActionView::Template.new
    #   # JbuilderTemplate.new(context).render
    #
    #   # xx = ::Proc.new do |json|
    #   #   json.jason do
    #   #     aa '1212'
    #   #     #json.partial! partial: "body"#, locals: {json: json}#, *args
    #   #   end
    #   # end
    #   # file = File.open("_body.jbuilder", "rb")
    #   # contents = file.read
    #
    #   # raise "===================>#{x}"
    #   # Template.find_by_name(tmpl)
    #
    #   # j = JbuilderTemplate.new(@context) do |json|
    #   #   json.jason do
    #   #     json.partial! name#, layout: true, layout: "body"
    #   #     # raise "=======================>#{x}"
    #   #     # render_to_string "users/profile"#, :layout => false
    #   #   end
    #   # end
    #   # JbuilderTemplate.new(@context) do |json|
    #   # end
    #   # file = File.open("#{Rails.root}/app/views/posts/_body.jbuilder", "rb")
    #   # source = <<-RUBY
    #   #   json.jason do
    #   #     instance_eval("#{file.read}")
    #   #   end
    #   # RUBY
    #   # # raise "=================>#{source}"
    #   # JbuilderTemplate.new(@context) do |json|
    #   #   instance_eval(source)
    #   # end
    #
    #   # builder = JasonSingleton.fetch(@context)
    #   # builder.with_attributes { ::Proc.new { source } }
    #
    #
    #
    #   # raise "=================>#{file.read}"
    #   # @context.lookup_context.find_file('posts/_body').inspect
    #   raise "=#{@context.lookup_context.methods}======#{@context.lookup_context.find_file(name, @context.lookup_context.prefixes, true).source}====#{}==============="
    #   # template = ActionView::Template.new(source, nil, JbuilderHandler, virtual_path: nil)
    #   # json = template.render('body', {}).strip
    #   # p "=============>#{json}"
    #
    #   # builder = JasonSingleton.fetch(template)
    #   # json = template.source
    #   # builder.with_attributes { instance_eval() }
    #   # @attributes.merge! j.attributes!
    #   self
    # end

    # def head &block
    #   builder = Jasonette::Jason::Head.new(@context)
    #   builder.with_attributes { instance_eval(&block) }
    #   set! "head", builder.attributes!
    #   self
    # end

    def template &block
      puts '@' * 40, 'template'

      builder = Jasonette::Jason::Template.new(@context)
      builder.with_attributes { instance_eval(&block) }
      _set_value "template", builder.attributes!
      self
    end

    def body &block
      puts '@' * 40, 'body'

      builder = Jasonette::Jason::Body.new(@context)
      builder.with_attributes { instance_eval(&block) }
      _set_value "body", builder.attributes!
      self
    end
  end

  ::Jbuilder.send(:include, JbuilderExtensions)
end
