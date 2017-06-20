require 'jasonette/template'

RSpec.describe Jasonette::Template do
  let(:builder) { build_with(described_class) }

  context "$jason" do
    it "#jason with head and title" do
      results = builder.jason do
        head do
          title "Foobar"
        end
      end

      expect(results.target!).to eq "{\"$jason\":{\"head\":{\"title\":\"Foobar\"}}}"
    end

    it "#jason with head and title" do
      build = builder.jason do
        head do
          title "Head"
        end
      end
      expect(JSON.parse(build.target!)).to eq "$jason" => {"head" => {"title" => "Head"}}
    end

    it "#jason with head and title" do
      build = builder.jason do
        head do
          title "Head"
          foo "bar"
        end
      end
      expect(JSON.parse(build.target!)).to eq "$jason" => {"head" => {"title" => "Head", "foo" => "bar"}}
    end

    it "#jason with head and title" do
      build = builder.jason do
        head.title "Head"
      end
      expect(JSON.parse(build.target!)).to eq "$jason" => {"head" => {"title" => "Head"}}
    end

    it "#jason with head and title" do
      build = builder.jason do
        head.title "Head"
        head.foo "bar"
      end
      expect(JSON.parse(build.target!)).to eq "$jason" => {"head" => {"title" => "Head", "foo" => "bar"}}
    end

    it "#jason with head and title" do
      build = builder.jason do
        head.title "Head"
        body do
          header.title "Header"
        end
      end
      expect(JSON.parse(build.target!)).to eq "$jason" => {"head" => {"title" => "Head"}, "body" => {"header" => {"title" => "Header"}}}
    end

    it "#jason with head and title" do
      build = builder.jason do
        head.title "Head"
        body.header.title "Header"
      end
      expect(JSON.parse(build.target!)).to eq "$jason" => {"head" => {"title" => "Head"}, "body" => {"header" => {"title" => "Header"}}}
    end

    it "#jason with head and title" do
      build = jbuild do
        head do
          title "Foobar"
          foo "bar"
        end
      end
      expect(JSON.parse(build.target!)).to eq "$jason" => {"head" => {"title" => "Foobar", "foo" => "bar"}}
    end

    context "readme example" do
      describe "data blocks" do
        it "generates expected json" do
          build = jbuild do
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
          expect(JSON.parse(build.target!)).to match_response_schema("readme_examples/data_blocks")
        end
      end

      describe "style blocks using hashes" do
        it "generates expected json" do
          build = jbuild do
            head do
              title "Foobar"
              style "styled_row", font: "HelveticaNeue", size: 20, color: "#FFFFFF", padding: 10
              style "col", font: "RobotoBold", color: "#FF0055"
            end
          end
          expect(JSON.parse(build.target!)).to match_response_schema("readme_examples/style_blocks")
        end
      end
    end
  end

  context "build" do
    it "#jason with head and title" do
      results = builder.build "$$jason" do
        head do
          title "Foobar"
        end
      end

      expect(results.target!).to eq "{\"$$jason\":{\"head\":{\"title\":\"Foobar\"}}}"
    end
  end

  context "#image_url" do
    it "can use actionview asset helpers" do
      build = builder.image_url("foo.png")
      expect(build).to include "http", "/images/foo.png"
    end
  end

  describe "#as_json use" do
    context "without defination of as_json", shared_context: :remove_as_json do
      it "build wrong target!" do
        _builder = build_with(Jasonette::Jason) { color "1100" }
        build = jbuild do
          set! "style", [_builder]
        end
        expect(JSON.parse(build.target!)["$jason"]["style"].first).to_not include "color"
      end
    end

    context "with defination of as_json" do
      it "build target!" do
        _builder = build_with(Jasonette::Jason) { color "1100" }
        build = jbuild do
          set! "style", [_builder]
        end
        expect(JSON.parse(build.target!)["$jason"]).to eq "style" => [{"color"=>"1100"}]
      end
    end
  end
end
