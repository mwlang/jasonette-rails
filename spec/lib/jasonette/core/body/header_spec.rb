RSpec.describe Jasonette::Body::Header do

  let(:builder) { build_with(described_class) }

  it "#title" do
    results = builder.encode do
      title "Foobar"
    end
    expect(results).to eqj("title" => "Foobar")
  end

  it "#search" do
    results = builder.encode do
      search do
        name "Foo"
        placeholder "Type here"
        action do
          trigger "search_for_it"
        end
        style do
          background "#555555"
          color "#FFFFFF"
        end
      end
    end
    expect(results).to eqj("search"=>{"name"=>"Foo", "placeholder"=>"Type here", "action"=>{"trigger"=>"search_for_it"}},
      "style" => {"background"=>"#555555", "color"=>"#FFFFFF"})
  end

  it "#menu" do
    results = builder.encode do
      menu "Tap me", "image_url"  do
        name "Foo"
        action do
          trigger "search_for_it"
        end
        style do
          background "#555555"
          color "#FFFFFF"
        end
        badge "3" do
          style do
            background "#444444"
          end
        end
      end
    end
    expect(results).to eqj("menu"=>{
      "text"=>"Tap me", "image"=>"image_url", "name"=>"Foo",
      "badge"=>{"text"=>"3", "style"=>{"background"=>"#444444"}},
      "action"=>{"trigger"=>"search_for_it"},
      "style"=>{"background"=>"#555555", "color"=>"#FFFFFF"}}
    )
  end
end
