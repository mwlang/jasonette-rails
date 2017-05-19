module Jasonette
  class Action < Jasonette::Base
    property :options
    property :success
    property :error

    def trigger name, &block
      with_attributes do
        set! "trigger", name
        encode(&block) if block_given?
      end
    end

    def render!
      set! "type", "$render"
    end

    def reload!
      set! "type", "$reload"
    end

    def success &block
      @success = Jasonette::Action.new(context) do
        block_given? ? encode(&block) : render!
      end
      self
    end

    def error &block
      @error = Jasonette::Action.new(context, &block)
      self
    end
  end
end
