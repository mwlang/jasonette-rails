RSpec.describe Jasonette::Base do

  let(:builder) { build_with(Jasonette::Base) }

  context "#image_url" do
    it "can use actionview asset helpers" do
      build = builder.image_url("foo.png")
      expect(build).to eq "/images/foo.png"
    end
  end

  context "partial!" do
    it "loads partials" do
      pending "it works within Rails app!  Why not here?"
      build = builder.inline! "foo"
      expect(build.attributes!).to eq({"$jason" => {"head" => {"title" => "{ ˃̵̑ᴥ˂̵̑}"}}})
    end
  end

  context "opening act" do
    it "any missing method opens named block" do
      build = builder.match do
        current_set "0"
        max_sets "5"
      end
      expect(build).to eqj({"match"=>{"current_set"=>"0", "max_sets"=>"5"}})
    end
  end

  context "#_method" do
    it "build in method with name" do
      build = builder.encode do
        _method "Foo"
      end
      expect(build.attributes!).to eqj("method" => "Foo")
    end

    it "build in method with block" do
      build = builder.encode do
        _method do
          item "Foo"
        end
      end
      expect(build.attributes!).to eqj("method" => {"item" => "Foo"})
    end
  end

  # "match": [{
  #   "current_set": "0",
  #   "max_sets": "3",
  #   "home": [
  #     { "score": "0", "tiebreak": "0" },
  #     { "score": "0", "tiebreak": "0" },
  #     { "score": "0", "tiebreak": "0" },
  #     { "score": "0", "tiebreak": "0" },
  #     { "score": "0", "tiebreak": "0" },
  #   ],
  #   "away": [
  #     { "score": "0", "tiebreak": "0" },
  #     { "score": "0", "tiebreak": "0" },
  #     { "score": "0", "tiebreak": "0" },
  #     { "score": "0", "tiebreak": "0" },
  #     { "score": "0", "tiebreak": "0" },
  #   ]
  # }]
  it "generates expected json" do
    pending "get inline! working in test environment -- works in Rails app!"
    expect(builder.inline!("score")).to match_response_schema("zero_scores")
  end  
end
