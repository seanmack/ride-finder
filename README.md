# Ride Finder

Ride Finder is a code example of an endpoint for a ride-scheduling service. It's
built with Ruby on Rails and uses Redis and Sidekiq for background jobs.

The sole endpoint returns a paginated list of rides sorted by potential earnings per hour.

## Prerequisites

You'll need the following installed

- Ruby 3.0 or higher
- Redis - `brew redis`
- PostgreSQL - `brew install postgresql`
- bundler - `gem install bundler`

## Quick start

1. Make sure postgres is running
1. `bin/setup`
   - Install dependencies and setup the database
1. `bin/rails credentials:edit`
   - Add the below ([how to get an API key](https://developers.google.com/maps/documentation/directions/start#create-project)):
     ```
       google_maps:
         api_key: your-api-key
     ```
1. `bundle exec sidekiq`
   - Run jobs enqueued by `seeds.rb`, e.g. to create and populate `Trips` using Google Directions API data
1. `bundle exec rspec`
   - Optional: run the test suite
1. `bin/rails s`
   - Start the server
1. `rake trips:recompile_metrics`
   - Optional: reset all trip metrics (enqueues jobs that call Google Directions API)

## Viewing the data

```bash
curl "http://localhost:3000/api/v1/rides?driver_id=1&page=1"

```

You should see something like the below. Change the `driver_id` and `page` parameters to view different result sets.

```
{
   "data" : [
      {
         "driver_id" : 1,
         "ride_id" : 3,
         "score" : "$32.66"
      },
      {
         "driver_id" : 1,
         "ride_id" : 6,
         "score" : "$29.53"
      },
      {
         "driver_id" : 1,
         "ride_id" : 9,
         "score" : "$24.01"
      },
      {
         "driver_id" : 1,
         "ride_id" : 1,
         "score" : "$23.94"
      },
      {
         "driver_id" : 1,
         "ride_id" : 2,
         "score" : "$22.17"
      }
   ],
   "paging" : {
      "current_page" : 1,
      "next_page" : 2,
      "next_url" : "/api/v1/rides?driver_id=1&page=2",
      "prev_url" : "/api/v1/rides?driver_id=1&page=",
      "total_records_count" : 10
   }
}
```

---

## How it works

### Driver

A `Driver` has an `address`.

The first leg of a trip starts here, so `address` can be considered the "origin" of the trip.

### Ride

A `Ride` has a `pick_up_address` and a `drop_off_address`.

The second leg of a trip starts at the `pick_up_address` and ends at the `destination_address`, so the former can be considered a "waypoint" and the latter the "destination."

### Trip

A `Trip` is a join model for `Ride` and `Driver`. It persists metrics related to the entire journey, from origin -> waypoint -> destination.

Trip metrics are retrieved from the Google Directions API and compiled into a `score`, which reflects the earnings per hour a driver might expect to earn for a particular ride.

The app uses `score` to order results for the `/rides` endpoint.
