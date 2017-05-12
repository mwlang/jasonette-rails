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
        items do
          image "foo_image_url", true, "image" do
            action do
              trigger "search_for_it"
              success { reload! }
            end
          end
        end
      end
    end
    expect(results).to eqj("style" =>{"background"=>"#555555","color"=>"#FFFFFF"},
      "input" =>{"left"=>{"image"=>"foo_image_url"},"right"=>{"text"=>"Back"}},
      "tabs" =>{"items"=>[{"image"=>"foo_image_url","action"=>{"trigger"=>"search_for_it","success"=>{"type"=>"$reload"}}}]})
  end
end
