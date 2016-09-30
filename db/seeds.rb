# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create([
  { first_name: "Baffled", last_name: "Baboon", email: "baboon@test.com", password: "Baffled_Baboon" },
  { first_name: "Upbeat", last_name: "Unicorn", email: "unicorn@test.com", password: "Upbeat_Unicorn" },
  { first_name: "Surreal", last_name: "Sloth", email: "sloth@test.com", password: "Surreal_Sloth" },
  { first_name: "Turbocharged", last_name: "Tanager", email: "tanager@test.com", password: "Turbocharged_Tanager" },
  { first_name: "Yearning", last_name: "Yak", email: "yak@test.com", password: "Yearning_Yak" },
  { first_name: "Massive", last_name: "Meerkat", email: "meerkat@test.com", password: "Massive_Meerkat" },
  { first_name: "Intrepid", last_name: "Iguana", email: "iguana@test.com", password: "Intrepid_Iguana" },
  { first_name: "Silly", last_name: "Squid", email: "squid@test.com", password: "Silly_Squid" },
  { first_name: "Heroic", last_name: "Hamster", email: "hamster@test.com", password: "Heroic_Hamster" },
  { first_name: "Angry", last_name: "Armadillo", email: "armadillo@test.com", password: "Angry_Armadillo" }
])