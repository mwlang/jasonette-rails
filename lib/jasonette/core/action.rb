module Jasonette
  class Action < Jasonette::Base
    property :options
    property :success
    property :error

    def trigger name, &block
      with_attributes do
        json.trigger name
        instance_eval(&block) if block_given?
      end
    end

    def render!
      with_attributes { json.type "$render" }
    end

    def reload!
      with_attributes { json.type "$reload" }
    end

    def success &block
      @success = Jasonette::Action.new(@context) do
        with_attributes do
          if block_given?
            instance_eval(&block)
          else
            json.type "$render"
          end
        end
      end
      self
    end

    def error &block
      @error = Jasonette::Action.new(@context) do
        with_attributes do
          instance_eval(&block)
        end
      end
      self
    end
  end
end
