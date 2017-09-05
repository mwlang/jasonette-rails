RSpec.describe "readme examples" do
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
        jason do
        end
      end
      expect(JSON.parse(build.target!)).to match_response_schema("readme_examples/data_blocks")
    end
  end

  describe "style blocks using hashes" do
    it "generates expected json" do
      build = jbuild do
        head.title "Foobar"

        head do
          style "styled_row", font: "HelveticaNeue", size: 20, color: "#FFFFFF", padding: 10
          style "col", font: "RobotoBold", color: "#FF0055"
        end
      end
      expect(JSON.parse(build.target!)).to match_response_schema("readme_examples/style_blocks")
    end
  end
end
