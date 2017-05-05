module Jasonette
  class Handler
    cattr_accessor :default_format
    self.default_format = Mime[:json]

    def self.call(template)
      # this juggling is required to keep line numbers right in the error
      %{__already_defined = defined?(json); json||=Jasonette::Template.new(self); #{template.source}
        json.target! unless (__already_defined && __already_defined != "method")}
    end
  end
end
