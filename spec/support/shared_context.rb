shared_context "without defination of as_json", :shared_context => :remove_as_json do
  before { class Jasonette::Base; remove_method(:as_json); end }
  after { load "#{"Jasonette::Core::Base".underscore}.rb" }
end