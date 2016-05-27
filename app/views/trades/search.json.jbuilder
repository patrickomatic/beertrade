json.array!(@results) do |result|
  json.extract! result, :id, :agreement, :completed_at, :created_at
  json.participants result.participants, partial: 'participants/show', as: :participant
  json.url trade_url(result)
end
