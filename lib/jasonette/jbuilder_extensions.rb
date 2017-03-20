module Jasonette
  class JasonSingleton
    private_class_method :new

    def self.fetch context
      return @@instance if defined?(@@instance) && @@instance
      puts 'FETCH' * 10
      @@instance = Jasonette::Jason.new(context)
    end

    def self.instance
      puts 'INSTANCE' * 8
      @@instance
    end

    def self.reset
      puts 'RESET' * 10
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
