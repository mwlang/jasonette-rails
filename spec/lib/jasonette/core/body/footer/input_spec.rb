RSpec.describe Jasonette::Body::Footer::Input do

  let(:builder) { build_with(described_class) }

  it "#left" do
    results = builder.encode do
      left "foo_image_url" do
        action do
          trigger "search_for_it"
          success { reload! }
        end
      end
    end
    expect(results).to eqj("left"=>{"url"=>"foo_image_url", "action"=>{"trigger"=>"search_for_it", "success"=>{"type"=>"$reload"}}})
  end

  it "#right" do
    results = builder.encode do
      right "Back" do
        action do
          trigger "back_me"
          success { reload! }
        end
      end
    end
    expect(results).to eqj("right" =>{"text"=>"Back", "action"=>{"trigger"=>"back_me", "success"=>{"type"=>"$reload"}}})
  end

  it "#textfield" do
    results = builder.encode do
      textfield "search" do
        placeholder "Search..."
        action do
          trigger "search_for_it"
          success { reload! }
        end
      end
    end
    expect(results).to eqj("textfield" => {"name"=>"search", "placeholder"=>"Search...", "action"=>{"trigger"=>"search_for_it", "success"=>{"type"=>"$reload"}}})
  end

  it "#style" do
    results = builder.encode do
      style do
        background "#555555"
        color "#FFFFFF"
      end
    end

    expect(results.attributes!).to eq("style" => {"background"=>"#555555", "color"=>"#FFFFFF"})
  end

end
