RSpec.describe Jasonette::Action do

  let(:builder) { build_with(described_class) }

  context "triggers" do

    # { "trigger": "foo"
    #   "success": {
    #     "type": "$render"
    #   }
    # }
    it "#trigger with success block" do
      build = builder.trigger("foo"){ success { type "$render" } }
      expect(build).to eqj({"trigger"=>"foo", "success"=>{"type"=>"$render"}})
    end

    # { "trigger": "foo",
    #   "success": {
    #     "trigger": "bar",
    #     "success" {
    #       "type": "$render"
    #     }
    #   }
    # }
    it "#trigger with success with another trigger and success block" do

      build = builder.trigger "foo" do
        success do
          trigger "bar" do
            success { type "$render" }
          end
        end
      end

      expect(build).to eqj({"trigger"=>"foo", "success"=>{"trigger"=>"bar", "success"=>{"type"=>"$render"}}})
    end

    # {
    #   "trigger": "some_action",
    #   "options": {
    #     "key1": "value1",
    #     "key2": "value2"
    #   },
    #   "success": {
    #     "type": "$render"
    #   },
    #   "error": {
    #     "type": "$render"
    #   }
    # }
    it "trigger with options, success, and error" do

      build = builder.trigger "some_action" do
        options do
          key1 "value1"
          key2 "value2"
        end
        success
        error { type "render" }
      end

      expect(build).to eqj({
        "trigger"=>"some_action",
        "options"=>{
          "key1"=>"value1",
          "key2"=>"value2"
        },
        "success"=>{"type"=>"$render"},
        "error"=>{"type"=>"render"}
      })
    end
  end

  context "#success" do

    # { "success": {
    #    "type": "$render"
    #   }
    # }
    it "just success" do
      build = builder.success
      expect(build).to eqj({"success"=>{"type"=>"$render"}})
    end

    # { "success": {
    #    "type": "$reload"
    #   }
    # }
    it "success w/block" do
      build = builder.success { type "$reload" }
      expect(build).to eqj({"success"=>{"type"=>"$reload"}})
    end
  end
end
