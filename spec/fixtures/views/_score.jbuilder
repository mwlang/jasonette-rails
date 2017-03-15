json.type "$cache.set"
json.options do
  json.match do
    json.current_set "0"
    json.max_sets "5"
    json.home do
      json.array! 5.times.map{"0"}
    end
    json.away do
      json.array! 5.times.map{"0"}
    end
  end
end
