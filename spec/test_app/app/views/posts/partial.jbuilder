json.jason do
  json.partial! "body_partial"
  partial! "foo", built_as: :json
end
