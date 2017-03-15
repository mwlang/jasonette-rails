module Jasonette
  class Style < Jasonette::Base
    def set_style name, *args, &block
      raise [name, args, block_given?].inspect
      @attributes[name.to_s] = value
    end
  end
end
