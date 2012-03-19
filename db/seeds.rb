# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create! do |u|
  u.email = 'rlotufo@gsd.uwaterloo.ca'
  u.password = 'default_password'
  u.password_confirmation = 'default_password'
end

Admin.create! do |u|
  u.email = 'zmalik@gsd.uwaterloo.ca'
  u.password = 'default_password'
  u.password_confirmation = 'default_password'
end
