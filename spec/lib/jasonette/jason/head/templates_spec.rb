RSpec.describe Jasonette::Jason::Head::Templates do

  let(:builder) { build_with(described_class) }

  it "builds a body" do
    builder.set_target_name('body_foo')
    results = builder.encode do
      sections do
        items do
          image "{{$jason.image}}"
          label "{{$jason.text}}"
        end
      end
    end

    expect(results.attributes!).to eq ({
      "body_foo" => {
        "sections" => [{
          "items" => [{
            "type" => "image",
            "url" => "{{$jason.image}}"
          }, {
            "type" => "label",
            "text" => "{{$jason.text}}"
          }]
        }]
      }
    })
  end
end
