namespace :trips do
  desc "Recompiles metrics for all trips"
  task recompile_metrics: :environment do
    Trip.find_each(batch_size: 100) do |trip|
      trip.compile_metrics!
    end
  end
end
