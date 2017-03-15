RSpec.describe Jasonette::Sections do

  it "#title" do
    results = build_with(described_class) do
      title "Foobar"
    end
    expect(results.attributes).to eqj({"title" => "Foobar"})
  end

  it "#search" do
    results = build_with(described_class) do
      items do
        label "Foo"
        label "Bar"
      end
    end

    expect(results.attributes!).to eq({
      "items"=>[
        {"text"=>"Foo", "type"=>"label"},
        {"text"=>"Bar", "type"=>"label"}
      ]
    })
  end
end
