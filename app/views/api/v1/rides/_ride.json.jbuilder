json.cache! [ride] do
  json.extract! ride, :ride_id, :driver_id
  json.score sprintf("$%.2f", ride.score.to_f / 100)
end
