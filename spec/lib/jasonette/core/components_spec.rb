RSpec.describe Jasonette::Components do

  context "labels" do
    it "builds a bare label" do
      build = build_with(described_class) do
        label "Check out Live DEMO"
      end

      expect(build.attributes!).to eq({ "components"=>[ { "type"=>"label", "text"=>"Check out Live DEMO", }] })
    end

    it "builds a simple label" do
      build = build_with(described_class) do
        label "Check out Live DEMO" do
          href do
            url "file://demo.json"
            fresh "true"
          end
        end
      end

      expect(build.attributes!).to eq({
        "components"=>[
          {
            "type"=>"label",
            "text"=>"Check out Live DEMO",
            "href"=>{
              "url"=>"file://demo.json",
              "fresh"=>"true"
            }
          }
        ]
      })
    end

    it "builds multiple labels" do
      build = build_with(described_class) do
        label "one" do
          href do
            url "file://demo.json"
          end
        end
        label "two" do
          href do
            url "file://login.json"
          end
        end
        label "three"
      end

      expect(build.attributes!).to eq({
        "components"=>[
          {
            "type"=>"label",
            "text"=>"one",
            "href"=>{
              "url"=>"file://demo.json",
            }
          },
          {
            "type"=>"label",
            "text"=>"two",
            "href"=>{
              "url"=>"file://login.json",
            }
          },
          {
            "type"=>"label",
            "text"=>"three",
          },
        ]
      })
    end

    it "builds a label with klass" do
      build = build_with(described_class) do
        label "klass" do
          klass "fancy_label"
        end
      end

      expect(build.attributes!).to eq({
        "components"=>[
          {
            "type"=>"label",
            "text"=>"klass",
            "class"=> "fancy_label",
          }
        ]
      })
    end

    it "builds a label with css_class" do
      build = build_with(described_class) do
        label "css_class" do
          css_class "fancy_label"
        end
      end

      expect(build.attributes!).to eq({
        "components"=>[
          {
            "type"=>"label",
            "text"=>"css_class",
            "class"=> "fancy_label",
          }
        ]
      })
    end

    it "builds a fancy label" do
      build = build_with(described_class) do
        label do
          text "Check out Live DEMO"
          style do
            align "right"
            padding "10"
            color "#000000"
            font "HelveticaNeue"
            size "12"
          end

          href do
            url "file://demo.json"
            fresh "true"
          end
        end
      end
      expect(build.attributes!).to eq({
        "components"=>[
          {
            "type"=>"label",
            "text"=>"Check out Live DEMO",
            "style"=>{
              "align"=>"right",
              "padding"=>"10",
              "color"=> "#000000",
              "font"=>"HelveticaNeue",
              "size"=>"12"
            },
            "href"=>{
              "url"=>"file://demo.json",
              "fresh"=>"true"
            }
          }
        ]
      })
    end
  end
end
