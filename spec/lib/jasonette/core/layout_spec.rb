RSpec.describe Jasonette::Layout do

  it "#components" do
    results = build_with(described_class) do
      components do
        label "Foo"
        label "Bar"
      end
    end

    expect(results.attributes!).to eq({
      "components"=>[
        {"text"=>"Foo", "type"=>"label"},
        {"text"=>"Bar", "type"=>"label"}
      ]
    })
  end
end
