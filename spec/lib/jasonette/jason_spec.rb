RSpec.describe Jasonette::Jason do

  let(:builder) { build_with(described_class) }

  require 'pry'

  context "$jason" do
    it "builds" do
      results = builder.encode do
        head { title "Foobar" }
      end
      expect(results.attributes!).to eq({"head" => {"title" => "Foobar"}})
    end

    it "builds" do
      results = builder.encode do
        head.title "Foobar"
      end
      expect(results.attributes!).to eq({"head" => {"title" => "Foobar"}})
    end
  end

=begin
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
    expect(builder.partial("score")).to match_response_schema("zero_scores")
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

  context "actions" do

    # { "$load": {
    #   "trigger": "load",
    #   "success": {
    #     "type": "$render"
    #     }
    #   }
    # }
    it "#action $load witn onload trigger and success block" do
      build = builder.action "$load" do
        trigger "onload"
        success { type "$render" }
      end
      expect(build).to eqj({"$load"=>{"trigger"=>"onload", "success"=>{"type"=>"$render"}}})
    end

    # { "$load": {
    #   "trigger": "load",
    #   "success": {
    #     "type": "$render"
    #     }
    #   }
    # }
    it "#action $load w/just onload trigger" do
      build = builder.action("$load") { trigger "onload" }
      expect(build).to eqj({"$load" => {"trigger"=>"onload"}})
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
=end
end
