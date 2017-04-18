json.jason do
  head do
    title "Matchpoint"
    action("$foreground") { reload! }
    action("$pull") { reload! }
    action "$load" do
      trigger "onload"
      success { render! }
    end
    action :onload do
      partial! "data/authenticity_token"
      success { trigger "set_score" }
    end
  end
end
