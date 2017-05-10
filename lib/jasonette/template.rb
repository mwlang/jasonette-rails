module Jasonette

  class JasonSingleton
    private_class_method :new

    def self.fetch context, &block
      if (defined?(@@instance) && @@instance)
        return @@instance if !context.nil? && (instance.context == context)
        reset
      end
      @@instance = Jasonette::Jason.new(context)
    end

    def self.instance
      @@instance
    end

    def self.reset
      @@instance = nil
    end
  end

  class Template < Jasonette::Base
    attr_accessor :partial_lookup_options

    def j
      JasonSingleton.fetch(context)
    end

    # TODO : remove
    # def initialize context
    #   self.extend ContexEmbedder if @context.present?
    #   super context
    # end

    def jason &block
      builder = JasonSingleton.fetch(context)

      if partial_lookup_options
        parent_builder = partial_lookup_options[:handler]
        parent_builder.with_partial_attributes self, &block
      else
        if has_layout?
          _set_key_value "$jason_outflow_content", block.source
        else
          _set_key_value "$jason", builder.encode(&block).attributes!
        end
      end
      self
    end

    def build name, &block
      builder = JasonSingleton.fetch(@context)
      builder.with_attributes { instance_eval(&block) }
      _set_key_value name, _scope { builder.attributes! }
      self
    end

    def has_layout?
      _has_layout = j.instance_variable_get("@_has_layout") || false
      j.instance_variable_set("@_has_layout", false)
      _has_layout
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
    #   _set_key_value "template", builder.attributes!
    #   self
    # end
    #
    # def body &block
    #   puts '@' * 40, 'body'
    #
    #   builder = Jasonette::Jason::Body.new(@context)
    #   builder.with_attributes { instance_eval(&block) }
    #   _set_key_value "body", builder.attributes!
    #   self
    # end
  end
end
