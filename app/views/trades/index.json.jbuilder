json.array!(@trades) do |trade|
  json.extract! trade, :id
  json.url trade_url(trade, format: :json)
end
