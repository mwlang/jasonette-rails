RSpec.describe Jasonette::Options do

  let(:builder) { build_with(described_class) }

  describe "data" do
    it "builds as a single pair of key/value" do
      results = builder.encode do
        data do
          name "Foo"
        end
      end
      expect(results).to eqj "data" => {"name" => "Foo"}
    end

    # # Removed :is_many, :is_single type in data property
    # it "builds data as an array" do
    #   results = builder.encode do
    #     data do
    #       name "Foo"
    #     end
    #     data do
    #       name "Bar"
    #     end
    #   end
    #   expect(results).to eqj({
    #     "data" => [{"name" => "Foo"}, {"name" => "Bar"}]
    #   })
    # end
    #
    # it "builds data as a pair of key/value" do
    #   results = builder.encode do
    #     data "FooKey" do
    #       name "Foo"
    #     end
    #     data do
    #       name "Bar"
    #     end
    #   end
    #   expect(results).to eqj({
    #     "data" => { "FooKey" => {"name" => "Foo"}, "name" => "Bar" }
    #   })
    # end

    describe "authenticity_token" do
      context "with protect_against_forgery" do
        it "builds authenticity_token" do
          allow_any_instance_of(ActionController::Base).to receive(:protect_against_forgery?).and_return(true)
          allow_any_instance_of(ActionController::Base).to receive(:form_authenticity_token).and_return("AUTH_TOKEN")
          results = builder.encode do
            data do
              name "Foo"
            end
          end
          expect(results).to eqj "data" => {"name"=>"Foo", "authenticity_token"=>"AUTH_TOKEN"}
        end
      end

      context "without protect_against_forgery" do
        it "not builds authenticity_token" do
          allow_any_instance_of(ActionController::Base).to receive(:protect_against_forgery?).and_return(false)
          results = builder.encode do
            data do
              name "Foo"
            end
          end
          expect(results).to eqj "data" => {"name" => "Foo"}
        end
      end
    end
  end

  it "builds form as an array" do
    results = builder.encode do
      form do
        name "Foo"
      end
      form do
        name "Bar"
      end
    end
    expect(results).to eqj({
      "form" => [{"name" => "Foo"}, {"name" => "Bar"}]
    })
  end

  it "builds action on $timer.start" do
    results = builder.encode do
      interval "1"
      name "timer1"
      action do
        type "$render"
        success
        error { type "render" }
      end
    end
    expect(results).to eqj({
      "interval" => "1", "name" => "timer1", "action" => {"type"=>"$render", "success"=>{"type"=>"$render"}, "error"=>{"type"=>"render"}}
    })
  end

  it "builds options for $lambda action" do
    results = builder.encode do
      name "lambda.timer"
      options do
        form do
          name "Bar"
        end
      end
    end
    expect(results).to eqj "name" => "lambda.timer", "options" => {"form" => [{"name" => "Bar"}]}
  end
end
