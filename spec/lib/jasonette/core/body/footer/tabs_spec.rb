RSpec.describe Jasonette::Body::Footer::Tabs do

  let(:builder) { build_with(described_class) }

  it "#style" do
    results = builder.encode do
      style do
        background "#555555"
        color "#FFFFFF"
      end
    end

    expect(results).to eqj("style" => {"background"=>"#555555", "color"=>"#FFFFFF"})
  end

  it "#items" do
    results = builder.encode do
      items do
        image "foo_image_url" do
          action do
            trigger "search_for_it"
            success { reload! }
          end
        end
        image "bar_image_url" do
          action do
            trigger "bar_for_it"
            success { reload! }
          end
        end
      end
    end

    expect(results).to eqj("items" => [
      {"type"=>"image", "url"=>"foo_image_url", "action"=>{"trigger"=>"search_for_it", "success"=>{"type"=>"$reload"}}},
      {"type"=>"image", "url"=>"bar_image_url", "action"=>{"trigger"=>"bar_for_it", "success"=>{"type"=>"$reload"}}}
    ])
  end

end
