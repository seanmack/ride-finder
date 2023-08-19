# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

driver_addresses = [
  {street_1: "777 Brockton Avenue", street_2: "", city: "Abington", state: "MA", zip: "2351"},
  {street_1: "30 Memorial Drive", street_2: "", city: "Avon", state: "MA", zip: "2322"},
  {street_1: "250 Hartford Avenue", street_2: "", city: "Bellingham", state: "MA", zip: "2019"},
  {street_1: "700 Oak Street", street_2: "", city: "Brockton", state: "MA", zip: "2301"},
  {street_1: "66-4 Parkhurst Rd", street_2: "", city: "Chelmsford", state: "MA", zip: "1824"},
  {street_1: "591 Memorial Dr", street_2: "", city: "Chicopee", state: "MA", zip: "1020"},
  {street_1: "55 Brooksby Village Way", street_2: "", city: "Danvers", state: "MA", zip: "1923"},
  {street_1: "137 Teaticket Hwy", street_2: "", city: "East Falmouth", state: "MA", zip: "2536"},
  {street_1: "42 Fairhaven Commons Way", street_2: "", city: "Fairhaven", state: "MA", zip: "2719"},
  {street_1: "374 William S Canning Blvd", street_2: "", city: "Fall River", state: "MA", zip: "2721"}
]

if Driver.count.zero?
  driver_addresses.each do |address|
    driver = Driver.create!(address:)
    puts "Created driver #{driver.id}"
  end
end

ride_addresses = [
  {
    pick_up_address: {street_1: "121 Worcester Rd", street_2: "", city: "Framingham", state: "MA", zip: "1701"},
    drop_off_address: {street_1: "677 Timpany Blvd", street_2: "", city: "Gardner", state: "MA", zip: "1440"}
  },
  {
    pick_up_address: {street_1: "337 Russell St", street_2: "", city: "Hadley", state: "MA", zip: "1035"},
    drop_off_address: {street_1: "295 Plymouth Street", street_2: "", city: "Halifax", state: "MA", zip: "2338"}
  },
  {
    pick_up_address: {street_1: "1775 Washington St", street_2: "", city: "Hanover", state: "MA", zip: "2339"},
    drop_off_address: {street_1: "280 Washington Street", street_2: "", city: "Hudson", state: "MA", zip: "1749"}
  },
  {
    pick_up_address: {street_1: "20 Soojian Dr", street_2: "", city: "Leicester", state: "MA", zip: "1524"},
    drop_off_address: {street_1: "11 Jungle Road", street_2: "", city: "Leominster", state: "MA", zip: "1453"}
  },
  {
    pick_up_address: {street_1: "301 Massachusetts Ave", street_2: "", city: "Lunenburg", state: "MA", zip: "1462"},
    drop_off_address: {street_1: "780 Lynnway", street_2: "", city: "Lynn", state: "MA", zip: "1905"}
  },
  {
    pick_up_address: {street_1: "70 Pleasant Valley Street", street_2: "", city: "Methuen", state: "MA", zip: "1844"},
    drop_off_address: {street_1: "830 Curran Memorial Hwy", street_2: "", city: "North Adams", state: "MA", zip: "1247"}
  },
  {
    pick_up_address: {street_1: "1470 S Washington St", street_2: "", city: "North Attleboro", state: "MA", zip: "2760"},
    drop_off_address: {street_1: "506 State Road", street_2: "", city: "North Dartmouth", state: "MA", zip: "2747"}
  },
  {
    pick_up_address: {street_1: "742 Main Street", street_2: "", city: "North Oxford", state: "MA", zip: "1537"},
    drop_off_address: {street_1: "72 Main St", street_2: "", city: "North Reading", state: "MA", zip: "1864"}
  },
  {
    pick_up_address: {street_1: "200 Otis Street", street_2: "", city: "Northborough", state: "MA", zip: "1532"},
    drop_off_address: {street_1: "180 North King Street", street_2: "", city: "Northhampton", state: "MA", zip: "1060"}
  },
  {
    pick_up_address: {street_1: "555 East Main St", street_2: "", city: "Orange", state: "MA", zip: "1364"},
    drop_off_address: {street_1: "555 Hubbard Ave-Suite 12", street_2: "", city: "Pittsfield", state: "MA", zip: "1201"}
  }
]

if Ride.count.zero?
  ride_addresses.each do |hash|
    ride = Ride.create!(
      pick_up_address: hash[:pick_up_address],
      drop_off_address: hash[:drop_off_address]
    )

    puts "Created ride #{ride.id}"
  end
end
