require 'jasonette/template'

module Jasonette
  class Handler
    cattr_accessor :default_format
    self.default_format = Mime[:json]

    def self.call(template)
      has_jasonette_handler = template.locals.include?("_jasonette_handler")
      %{__already_defined = defined?(jason); if(#{has_jasonette_handler}); _jasonette_handler.encode(&Proc.new {#{template.source}}); else; jason||=Jasonette::Template.new(self); if jason.has_layout?; jason.set!("$jason_outflow_content", '#{template.source.to_s.gsub("'", %q(\\\'))}'); else; jason.jason(&Proc.new {#{template.source}}); end; end;
        jason.target! unless ((__already_defined && __already_defined != "method") || #{has_jasonette_handler})}
    end
  end
end
