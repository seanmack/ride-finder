class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :ride

  # todo remove commute_distance

  after_create :compile_metrics!

  validates :driver_id, uniqueness: {scope: :ride_id}

  scope :order_by_score_desc, -> { order(score: :desc) }

  BASE_PAY_IN_CENTS = 1200

  OVERAGE_MILES_THRESHOLD = 5
  PAY_PER_OVERAGE_MILE_IN_CENTS = 150

  OVERAGE_MINUTES_THRESHOLD = 15
  PAY_PER_OVERAGE_MINUTE_IN_CENTS = 70

  def compile_metrics!
    AnalyzeTripJob.perform_async(id)
  end

  def calculate_score
    self.score = ride_earnings_in_cents_per_hour
  end

  private

  def ride_earnings_in_cents_per_hour
    cents_per_hour = ride_earnings_in_cents / trip_duration_in_hours
    cents_per_hour.round
  end

  def ride_earnings_in_cents
    (BASE_PAY_IN_CENTS + overage_distance_pay + overage_time_pay).round
  end

  def trip_duration_in_hours
    (commute_duration + ride_duration) / 60.0
  end

  def overage_distance_pay
    overage_miles = ride_distance_in_miles - OVERAGE_MILES_THRESHOLD
    return 0 if overage_miles.negative?

    overage_miles * PAY_PER_OVERAGE_MILE_IN_CENTS
  end

  def overage_time_pay
    overage_minutes = ride_duration - OVERAGE_MINUTES_THRESHOLD
    return 0 if overage_minutes.negative?

    overage_minutes * PAY_PER_OVERAGE_MINUTE_IN_CENTS
  end

  def ride_distance_in_miles
    meters = ride_distance
    (meters * 0.000621371).round(1)
  end
end
