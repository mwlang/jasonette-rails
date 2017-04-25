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

  context "$jason" do

    # { "$jason": {
    #   "head": {
    #     "title": "Foobar"
    #   }
    # }
    it "#jason with head and title" do
      build = jbuild.jason do
        head do
          title "Foobar"
          foo "bar"
        end
      end
      expect(build).to eqj("$jason" => {"head" => {"title" => "Foobar", "foo" => "bar"}})
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
      build = jbuild.jason do
        _method "Foo"
      end
      expect(build.attributes!).to eqj("$jason" => {"method" => "Foo"})
    end

    it "build in method with block" do
      build = jbuild.jason do
        _method do
          item "Foo"
        end
      end
      expect(build.attributes!).to eqj("$jason" => {"method" => {"item" => "Foo"}})
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

  context "readme example" do
    describe "data blocks" do
      it "generates expected json" do
        build = jbuild.jason do
          head do
            title "Beatles"
            data.names ["John", "George", "Paul", "Ringo"]
            data.songs [
              { album: "My Bonnie", song: "My Bonnie" },
              { album: "My Bonnie", song: "Skinny Minnie" },
              { album: "Please Please Me", song: "I Saw Her Standing There" },
            ]
          end
        end
        expect(build.attributes!).to match_response_schema("readme_examples/data_blocks")
      end
    end

    describe "style blocks using hashes" do
      it "generates expected json" do
        build = jbuild.jason do
          head do
            title "Foobar"
            style "styled_row", font: "HelveticaNeue", size: 20, color: "#FFFFFF", padding: 10
            style "col", font: "RobotoBold", color: "#FF0055"
          end
        end
        expect(build.attributes!).to match_response_schema("readme_examples/style_blocks")
      end
    end
  end

  it "set key/values that are not easily expressed as method" do
    build = builder.encode do
      set! "color:disabled", "1100"
    end
    expect(build).to eqj "color:disabled"=>"1100"
  end
end
