module Jasonette
  class Jason::Body < Jasonette::Base
    property :header
    property :sections, true

    def attributes!
      attributes = super
      attributes.delete "sections" if attributes.has_key?("sections")
      if !@all_sections.nil?
        attributes["sections"] = [] if attributes["sections"].nil? || attributes["sections"].empty?
        @all_sections.each do |sections|
          attributes["sections"] << sections.attributes!
        end
      end
      attributes
    end
  end
end
