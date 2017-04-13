RSpec.describe Jasonette::Jason::Head::Actions do

  let(:builder) { build_with(described_class) }

  it "builds a data" do
    results = builder.encode do
      type "$network.request"
      options do
        url "https://url/submit"
        action_method "POST"
        data do
          id '12'
          name 'Samule'
        end
      end
      success do
        type "$render"
      end
    end

    expect(results.attributes!).to eq ({
      "type" => "$network.request",
      "success" => { "type" => "$render" },
      "options" => {
        "url" => "https://url/submit",
        "method" => "POST",
        "data" => [
          { "id" => "12", "name" => "Samule" }
        ]
      }
    })
  end
end
