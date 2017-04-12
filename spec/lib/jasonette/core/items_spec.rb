RSpec.describe Jasonette::Items do

  context "labels" do
    it "builds a bare label" do
      build = build_with(described_class) do
        label "Check out Live DEMO"
      end

      expect(build.attributes!).to eq({ "items"=>[ { "type"=>"label", "text"=>"Check out Live DEMO", }] })
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
        "items"=>[
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
        "items"=>[
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
        "items"=>[
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
        "items"=>[
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
        "items"=>[
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

    it "builds an action on lable" do
      build = build_with(described_class) do
        label do
          text "Check out Live DEMO"
          action do
            type "$network.request"
            options do
              url "https://url/submit"
              action_method "POST"
            end
            success do
              type "$render"
            end
            error do
              type "$util.banner"
              options do
                title "Error"
                description "Something went wrong."
              end
            end
          end
        end
      end
      expect(build.attributes!).to eq({
        "items"=>[{
          "type"=>"label",
          "text"=>"Check out Live DEMO",
          "action" => {
            "type" => "$network.request",
            "options" => {
              "url" => "https://url/submit",
              "method" => "POST"
            },
            "success" => { "type" => "$render"  },
            "error" => {
              "type" => "$util.banner",
              "options" => {
                "title" => "Error",
                "description" => "Something went wrong."
              }
            }
          }
        }]
      })
    end

    it "builds an action trigger lable" do
      build = build_with(described_class) do
        label do
          text "Check out Live DEMO"
          action do
            trigger "refresh_view"
          end
        end
      end
      expect(build.attributes!).to eq({
        "items"=>[{
          "type"=>"label",
          "text"=>"Check out Live DEMO",
          "action" => { "trigger" => "refresh_view" }
        }]
      })
    end
  end
end
