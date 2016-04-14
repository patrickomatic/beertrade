json.array!(@trades) do |trade|
  json.extract! trade, :id, :agreement, :completed_at, :created_at
  json.participants trade.participants, partial: 'participants/show', as: :participant
  json.url trade_url(trade)
end
