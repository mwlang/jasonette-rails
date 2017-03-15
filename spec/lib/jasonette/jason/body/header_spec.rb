RSpec.describe Jasonette::Jason::Body::Header do

  let(:builder) { build_with(Jasonette::Jason::Body::Header) }

  it "#title" do
    results = builder.encode do
      title "Foobar"
    end
    expect(results).to eqj({"title" => "Foobar"})
  end

  it "#search" do
    results = builder.encode do
      search do
        name "Foo"
        placeholder "Type here"
        action.trigger "search_for_it"
        style.background "#555555"
        style.color "#FFFFFF"
      end
      expect(results).to eq({"title" => "Foobar"})
    end
  end
end
