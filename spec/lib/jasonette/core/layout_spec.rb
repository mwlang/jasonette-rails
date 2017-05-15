RSpec.describe Jasonette::Layout do

  it "#components" do
    results = build_with(described_class) do
      components do
        label "Foo"
        label "Bar"
      end
      action do
        type "$network.request"
        options do
          url "https://url/submit"
          action_method "POST"
        end
        success { render! }
      end
      style do
        align "right"
      end
    end

    expect(results.attributes!).to eq({
      "components"=>[
        {"text"=>"Foo", "type"=>"label"},
        {"text"=>"Bar", "type"=>"label"}
      ],
      "style" => {"align"=>"right"},
      "action" => {"type"=>"$network.request", "options"=>{"url"=>"https://url/submit", "method"=>"POST"}, "success"=>{"type"=>"$render"}}
    })
  end
end
