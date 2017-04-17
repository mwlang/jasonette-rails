require "json_matchers/rspec"

# TODO: Fully convert to Thoughtbot's matchers: https://github.com/thoughtbot/json_matchers
RSpec::Matchers.define :match_response_schema do |schema|
  match do |builder|
    schema_path = File.join("./spec/fixtures/json/schemas", "#{schema}.json")
    JSON::Validator.validate!(schema_path, builder.to_json, strict: true)
  end
end

RSpec::Matchers.define :eqj do |expected|
  match do |target|
    expected = JSON.parse(expected) if expected.is_a?(String)
    @actual = actual.attributes! unless actual.is_a?(Hash)
    @actual == expected
  end
  diffable
end
