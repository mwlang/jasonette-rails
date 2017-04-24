json.jason do
  action :onload do
    partial! "data/authenticity_token", built_as: :json
    success { trigger "set_score" }
  end
end
