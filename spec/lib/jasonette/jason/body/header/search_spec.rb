RSpec.describe Jasonette::Jason::Body::Header::Search do

  let(:builder) { build_with(described_class) }

  it "#name" do
    results = builder.encode do
      name "Foo"
      placeholder "Type here"
    end
    expect(results).to eqj({ "name" => "Foo", "placeholder" => "Type here" })
  end

  it "#title" do
    results = builder.encode do
      name "Foo"
      action do
        trigger "search_for_it"
        success { reload! }
      end
    end

    expect(results.attributes!).to eq({
      "name" => "Foo",
      "action" => {
        "trigger" => "search_for_it",
        "success" => {"type" => "$reload" }
      },
    })
  end

  it "#style" do
    results = builder.encode do
      name "Foo"
      style do
        background "#555555"
        color "#FFFFFF"
      end
    end

    expect(results.attributes!).to eq({
      "name" => "Foo",
      "style" => {
        "background" => "#555555",
        "color" => "#FFFFFF"
      }
    })
  end

end
