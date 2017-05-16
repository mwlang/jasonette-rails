RSpec.describe Jasonette::Options do

  let(:builder) { build_with(described_class) }

  it "builds data as a single pair of key/value" do
    results = builder.encode do
      data do
        name "Foo"
      end
    end
    expect(results).to eqj "data" => {"name" => "Foo"}
  end

  it "builds data as an array" do
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

  it "builds data as a pair of key/value" do
    results = builder.encode do
      data "FooKey" do
        name "Foo"
      end
      data do
        name "Bar"
      end
    end
    expect(results).to eqj({
      "data" => { "FooKey" => {"name" => "Foo"}, "name" => "Bar" }
    })
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
end
