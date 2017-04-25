RSpec.describe Jasonette::Jason::Head::Templates do

  let(:builder) { build_with(described_class) }

  it "builds a body with different name" do
    results = builder.encode do
      sections do
        items do
          image "{{$jason.image}}"
          label "{{$jason.text}}"
        end
      end
    end

    expect(results).to eqj ({
      "sections" => [{
        "items" => [{"type" => "image", "url" => "{{$jason.image}}"}, {"type" => "label", "text" => "{{$jason.text}}"}]
      }]
    })
  end
end
