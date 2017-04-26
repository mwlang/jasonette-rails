RSpec.describe Jasonette::Body::Footer do

  let(:builder) { build_with(described_class) }

  it "builds style, input and tabs" do
    results = builder.encode do
      style do
        background "#555555"
        color "#FFFFFF"
      end
      input do
        left "foo_image_url"
        right "Back"
      end
      tabs do
        image "foo_image_url" do
          action do
            trigger "search_for_it"
            success { reload! }
          end
        end
      end
    end
    expect(results).to eqj("input" => {"left"=>{"image"=>"foo_image_url"}, "right"=>{"text"=>"Back"}},
      "style" => {"background"=>"#555555", "color"=>"#FFFFFF"},
      "tabs" => {"image"=>{"action"=>{"trigger"=>"search_for_it"}}})
  end
end
