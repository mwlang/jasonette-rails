json.jason do
  action :onload do
    partial! "data/authenticity_token"
    success { trigger "set_score" }
  end
end
