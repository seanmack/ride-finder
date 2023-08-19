class RideAnalysisQuery
  def initialize(scope = Ride.all)
    @scope = scope
  end

  def call(driver_id:)
    @scope.joins(:trips)
      .where(trips: {driver_id: driver_id})
      .select("trips.updated_at, trips.score as score, trips.driver_id as driver_id, rides.id as ride_id")
      .order("trips.score desc")
      .distinct
  end
end
