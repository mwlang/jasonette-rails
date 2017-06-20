module Jasonette
  class Options < Jasonette::Base
    property :data#, :is_many, :is_single
    property :action
    property :form, :is_many
    property :items
    property :options

    def attributes!
      super
      if @attributes["data"].present? && context.protect_against_forgery?
        @attributes["data"].merge! "authenticity_token" => context.form_authenticity_token
      end
      @attributes
    end
  end
end
