json.paging do
  json.prev_url @pagy_metadata[:prev_url]
  json.next_url @pagy_metadata[:next_url]
  json.total_records_count @pagy_metadata[:count]
  json.current_page @pagy_metadata[:page]
  json.next_page @pagy_metadata[:next]
end

json.data do
  json.array! @rides, partial: "api/v1/rides/ride", as: :ride
end
