RSpec.describe Jasonette::Base do

  let(:builder) { build_with(described_class) }

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

  describe "#set!" do
    it "builds key/values that are not easily expressed as method" do
      build = builder.encode do
        set! "color:disabled", "1100"
      end
      expect(build).to eqj "color:disabled"=>"1100"
    end

    it "builds any simple value as string" do
      build = builder.encode do
        set! "color", 1
      end
      expect(build).to eqj "color"=>"1"
    end

    context "with Jasonette instance" do
      it "builds instance attributes!" do
        _builder = build_with(Jasonette::Jason).encode do
          color "1100"
        end
        build = builder.encode do
          set! "head", _builder
        end
        expect(build).to eqj "head" => {"color"=>"1100"}
      end
    end

    context "with Block" do
      it "builds content" do
        build = builder.encode do
          set! "color" do
            white "000000"
            black "fffff"
          end  
        end
        expect(build).to eqj "color" => {"white"=>"000000", "black"=>"fffff"}
      end

      context "having argument as collection" do  
        it "builds content with Array values" do
          build = builder.encode do
            set! "color", [{ encode: "000000", name: "white" }, { encode: "fffff", name: "black" }] do |color|
              set! color[:name], color[:encode]
            end  
          end
          expect(build).to eqj "color" => [{"white"=>"000000"}, {"black"=>"fffff"}]
        end

        it "builds content with Hash values" do
          build = builder.encode do
            set! "color", { "white"=>"000000", "black"=>"fffff" } do |color_name, encode|
              set! color_name, encode
            end  
          end
          expect(build).to eqj "color" => [{"white"=>"000000"}, {"black"=>"fffff"}]
        end
      end
    end

    context "without Block" do
      it "builds collection" do
        build = builder.encode do
          set! "color", [{ encode: "000000", name: "white" }, { encode: "fffff", name: "black" }], :encode, :name
        end
        expect(build).to eqj "color" => [{"encode"=>"000000", "name"=>"white"}, {"encode"=>"fffff", "name"=>"black"}]
      end
    end  
  end

  describe "#array!" do
    context "with Jasonette instance collections" do
      let(:builder1) { build_with(described_class) { set! "builder", "1" } }
      let(:builder2) { build_with(described_class) { set! "builder", "2" } }

      it "builds builder value" do
        collection = [builder1, builder2, {"no_builder"=>"3"}, 4]
        build = builder.encode do
          array! collection
        end
        expect(build).to eqj [{"builder"=>"1"}, {"builder"=>"2"}, {"no_builder"=>"3"}, 4]
      end
    end
  end  

  describe "#merge!" do
    context "with hash having symbolised key, integer value" do
      it "build hash key/value in string" do
        build = builder.encode do
          merge! title: "foo", "color" => "1100", file: 1 
        end
        expect(build).to eqj "title"=>"foo", "color"=>"1100", "file"=>"1"
      end
    end

    context "with Jasonette instance" do
      it "build attributes" do
        _builder = build_with(Jasonette::Jason) { color "1100" }
        build = builder.encode do
          merge! _builder
        end
        expect(build).to eqj "color"=>"1100"
      end
    end
  end

  describe "#as_json use" do
    context "without defination of as_json", shared_context: :remove_as_json do
      it "build wrong target!" do
        _builder = build_with(Jasonette::Jason) { color "1100" }
        build = builder.encode do
          set! "style", [_builder]
        end
        expect(JSON.parse(build.target!)["style"].first).to_not include "color"
      end
    end

    context "with defination of as_json" do
      it "build target!" do
        _builder = build_with(Jasonette::Jason) { color "1100" }
        build = builder.encode do
          set! "style", [_builder]
        end
        expect(JSON.parse(build.target!)).to eq "style" => [{"color"=>"1100"}]
      end
    end
  end

  describe "#encode" do
    context "with private method" do
      it do
        pending "instance_eval is responcible to anounce private methods to object"
        build = builder.encode do
          _set_key_value "style", "wow"
        end
        expect(build).to_not eqj "style"=>"wow"
      end
    end
  end
end
