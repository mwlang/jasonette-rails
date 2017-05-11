RSpec.describe Jasonette::Jason::Body do

  let(:builder) { build_with(described_class) }

  it "builds" do
    expect { builder.encode { head.title "Foobar" } }.to raise_error NoMethodError
  end

  it "uses Header class for header property" do
    results = build_with(described_class) do
      header do
        title "Foobar"
      end
    end
    expect(results.prop(:header)).to be_a Jasonette::Jason::Body::Header
    expect(results).to eqj({"header" => {"title" => "Foobar"}})
  end

  it "builds sections as an array" do
    results = builder.encode do
      sections do
        items do
          label "Foo"
          label "Bar"
        end
      end
    end
    expect(results.attributes!).to eq({
      "sections" => [
        {"items" => [
          {"type" => "label", "text" => "Foo"},
          {"type" => "label", "text" => "Bar"}, 
        ]}
      ]}
    )
  end

  it "builds many sections as an array" do
    results = builder.encode do
      sections do
        type "horizontal"
        items do
          label "Foo"
        end
      end
      sections do
        type "vertical"
        items do
          label "Bar"
        end
      end
    end
    expect(results.attributes!).to eq({
      "sections" => [
        { "type" => "horizontal",
          "items" => [
            {"type" => "label", "text" => "Foo"}
        ]},
        { "type" => "vertical",
          "items" => [
            {"type" => "label", "text" => "Bar"}
        ]}
      ]}
    )
  end

  it "builds layers as an array" do
    results = builder.encode do
      layers do
        label "Foo"
        label "Bar"
      end
    end
    expect(results.attributes!).to eq("layers"=>[{"text"=>"Foo", "type"=>"label"}, {"text"=>"Bar", "type"=>"label"}])
  end
end
