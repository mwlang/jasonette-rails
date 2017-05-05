module Jasonette
  class Action < Jasonette::Base
    property :options
    property :success
    property :error

    def trigger name, &block
      with_attributes do
        set! "trigger", name
        instance_eval(&block) if block_given?
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
        with_attributes do
          if block_given?
            instance_eval(&block)
          else
            render!
          end
        end
      end
      self
    end

    def error &block
      @error = Jasonette::Action.new(context) do
        with_attributes { instance_eval(&block) }
      end
      self
    end
  end
end
