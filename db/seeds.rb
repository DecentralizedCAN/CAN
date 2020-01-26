# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

ENV['ADMIN_EMAIL'] != nil ? admin_email = ENV['ADMIN_EMAIL'] : admin_email = "admin@fakeemail.com"
ENV['ADMIN_PASSWORD'] != nil ? admin_password = ENV['ADMIN_PASSWORD'] : admin_password = "adminpassword"

# User.create!(name:  "admin",
#              email: admin_email,
#              password:              admin_password,
#              password_confirmation: admin_password,
#              admin: true,
#              activated: true,
#              activated_at: Time.zone.now)

Setting.create!(title: "Allow any member to post", state: false)
Setting.create!(title: "Limit multiple posts within a short amount of time", state: false)
Setting.create!(title: "Allow users to sign up on their own", state: false)
Setting.create!(title: "Include a discussion section for brainstorms", state: false)
Setting.create!(title: "Include a discussion section for actions", state: false)
Setting.create!(title: "Make content viewable without an account", state: false)

10.times do |n|
  name  = "example-#{n+1}" #Faker::Name.name
  email = "example-#{n+1}@fakeemail.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end