RSpec.describe Jasonette::Jason::Body do

  let(:builder) { build_with(described_class) }

  it "builds" do
    results = builder.encode do
      head.title "Foobar"
    end
    expect(results).to eqj({"title" => "Foobar"})
  end

  it "finds Foo" do
    results = builder.encode do
      foo.title "Foobar"
    end
    expect(results).to eqj({"title" => "Foobar"})
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
end
