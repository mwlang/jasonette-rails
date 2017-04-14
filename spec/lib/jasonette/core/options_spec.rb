RSpec.describe Jasonette::Options do

  let(:builder) { build_with(described_class) }

  it "builds data as an array" do
    results = builder.encode do
      data do
        id "1"
        name "Bar"
      end
    end
    expect(results).to eqj({
      "data" => [{"id" => "1", "name" => "Bar"}]
    })
  end

  it "builds data as an array" do
    pending "Build only single data in Array, Not working for more then one data block"
    results = builder.encode do
      data do
        name "Foo"
      end
      data do
        name "Bar"
      end
    end
    expect(results).to eqj({
      "data" => [{"name" => "Foo"}, {"name" => "Bar"}]
    })
  end
end
