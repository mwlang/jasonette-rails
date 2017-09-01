RSpec.describe Jasonette::Items do

  context "labels" do
    it "builds a bare label" do
      build = build_with(described_class) do
        label "Check out Live DEMO"
      end

      expect(build).to eqj [{"type"=>"label", "text"=>"Check out Live DEMO"}]
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

      expect(build.attributes!).to eq([
        {
          "type"=>"label",
          "text"=>"Check out Live DEMO",
          "href"=>{
            "url"=>"file://demo.json",
            "fresh"=>"true"
          }
        }
      ])
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

      expect(build.attributes!).to eq([
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
        ])
    end

    it "builds a label with klass" do
      build = build_with(described_class) do
        label "klass" do
          klass "fancy_label"
        end
      end

      expect(build.attributes!).to eq([
        {
          "type"=>"label",
          "text"=>"klass",
          "class"=> "fancy_label",
        }
      ])
    end

    it "builds a label with css_class" do
      build = build_with(described_class) do
        label "css_class" do
          css_class "fancy_label"
        end
      end

      expect(build.attributes!).to eq([
        {
          "type"=>"label",
          "text"=>"css_class",
          "class"=> "fancy_label",
        }
      ])
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
      expect(build.attributes!).to eq([
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
      ])
    end

    it "builds an action on label" do
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
      expect(build).to eqj([
        {
          "type"=>"label",
          "text"=>"Check out Live DEMO",
          "action" => {
            "type" => "$network.request",
            "options" => { "url" => "https://url/submit", "method" => "POST" },
            "success" => { "type" => "$render"  },
            "error" => {
              "type" => "$util.banner",
              "options" => { "title" => "Error", "description" => "Something went wrong." }
            }
          }
        }
      ])
    end

    it "builds an action trigger with data on label" do
      build = build_with(described_class) do
        label do
          text "Check out Live DEMO"
          action do
            trigger "refresh_view"
            type "$network.request"
            options do
              url "https://url/submit"
              action_method "POST"
              data do
                id "12"
                name "Samule"
              end
            end
            success do
              type "$render"
            end
          end
        end
      end
      expect(build).to eqj([
        {
          "type"=>"label",
          "text"=>"Check out Live DEMO",
          "action" => {
            "trigger" => "refresh_view",
            "type" => "$network.request",
            "success" => { "type" => "$render" },
            "options" => {
              "url" => "https://url/submit",
              "method" => "POST",
              "data" => { "id" => "12", "name" => "Samule" }
            }
          }
        }
      ])
    end

    it "builds a simple text" do
      build = build_with(described_class) do
        text "Check out Live DEMO"
      end

      expect(build).to eqj([{"text"=>"Check out Live DEMO", "type"=>"text"}])
    end

    it "builds a simple video" do
      build = build_with(described_class) do
        video "file://demo.json"
      end

      expect(build).to eqj([{"type"=>"video","file_url"=>"file://demo.json"}])
    end

    it "builds a textfield" do
      build = build_with(described_class) do
        textfield "password", "foo1234" do
          placeholder "Password..."
        end
      end

      expect(build).to eqj([{"type"=>"textfield", "name"=>"password", "value"=>"foo1234", "placeholder"=>"Password..."}])
    end

    it "builds a textarea" do
      build = build_with(described_class) do
        textarea "status", "fooing..." do
          placeholder "Status update"
        end
      end

      expect(build).to eqj([{"type"=>"textarea", "name"=>"status", "value"=>"fooing...", "placeholder"=>"Status update"}])
    end
    context "button" do
      it "builds a button with caption" do
        build = build_with(described_class) do
          button "Click me"
        end

        expect(build).to eqj [{"type"=>"button", "text"=>"Click me"}]
      end

      it "builds a button with url" do
        build = build_with(described_class) do
          button "image_url", true
        end

        expect(build).to eqj [{"type"=>"button", "url"=>"image_url"}]
      end
    end

    it "builds a slider" do
      build = build_with(described_class) do
        slider "gauge", "2"
      end

      expect(build).to eqj [{"type"=>"slider", "name"=>"gauge", "value"=>"2"}]
    end

    it "builds map" do
      build = build_with(described_class) do
        map do
          style do
            type "satellite"
          end
        end
      end

      expect(build).to eqj [{"type"=>"map", "style"=>{"type"=>"satellite"}}]
    end

    it "builds html" do
      build = build_with(described_class) do
        html "<html>...<html>" do
          style do
            type "satellite"
          end
        end
      end

      expect(build).to eqj [{"type"=>"html", "text"=>"<html>...<html>", "style"=>{"type"=>"satellite"}}]
    end

    context "#merge!" do
      it "builds hash" do
        build = build_with(described_class) do
          merge! "add" => "2", "minus" => "1"
          merge! "add" => "0"
        end

        expect(build).to eqj [{"add"=>"2", "minus"=>"1"}, {"add"=>"0"}]
      end

      it "builds components" do
        build2 = build_with(described_class).text "Check out Live DEMO", true

        build = build_with(described_class) do
          merge! build2
        end

        expect(build).to eqj [{"text"=>"Check out Live DEMO"}]
      end
    end

    context "#set!" do
      it "builds block with key" do
        build = build_with(described_class) do
          set! "#each colors" do
            merge! "add" => "0"
          end
        end

        expect(build).to eqj "#each colors" => [{"add"=>"0"}]
      end

      it "raise HashError" do
        expect { build_with(described_class) do
          set! "#each colors" do
            merge! "add" => "0"
          end
          merge! "add" => "0"
        end }.to raise_error RuntimeError, "HashError : You may have used `set!` before"
      end
    end

    context "#skip_type" do
      it "simple text" do
        build = build_with(described_class) do
          text "Check out Live DEMO", true
        end

        expect(build).to eqj [{"text"=>"Check out Live DEMO"}]
      end
    end
  end
end
