require 'jasonette/helpers'

RSpec.describe Jasonette::Helpers do
  before do
    stub_const 'ContextBuilder', test_view_context_class.class
    context.class_eval{ include Jasonette::Helpers }
  end

  after do
    Jasonette::JasonSingleton.reset context
  end

  let(:context) { ContextBuilder.new }

  context "#jason_builder" do
    it "builds head" do
      results =  context.jason_builder :head do
        template :body do
          title "Foobar"
        end
      end

      expect(results).to eqj "templates" => {:body=>{"title"=>"Foobar"}}
    end
  end

  context "#jason_component" do
    it "raise Error" do
      expect {
        context.jason_component :head do
          template :body
        end
      }.to raise_error "Method `head` is not defined in Builder"
    end

    it "builds component" do
      results =  context.jason_component :textfield, :password, "Password" do
        action do
          success
        end
      end

      expect(results).to eqj "name" => "password", "type" => "textfield", "value" => "Password", "action" => {"success"=>{"type"=>"$render"}}
    end
  end
end
