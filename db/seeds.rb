# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Setting.create!(title: "Allow any member to post", state: false)
Setting.create!(title: "Limit multiple posts within a short amount of time", state: false)
Setting.create!(title: "Allow users to sign up on their own", state: false)
Setting.create!(title: "Include a discussion section for brainstorms", state: false)
Setting.create!(title: "Include a discussion section for actions", state: false)
Setting.create!(title: "Make content viewable without an account", state: false)
Setting.create!(title: "Require new members to provide an email address", state: false)
Setting.create!(title: "Allow users to receive emails (reduced security)", state: false)
Setting.create!(title: "Hide proposal participation and default to 1", state: false)
Setting.create!(title: "Allow facilitator mode", state: false)
Setting.create!(title: "Allow multiple scoring methods", state: false)

ENV['ADMIN_EMAIL'] != nil ? admin_email = ENV['ADMIN_EMAIL'] : admin_email = "admin@fakeemail.com"
ENV['ADMIN_PASSWORD'] != nil ? admin_password = ENV['ADMIN_PASSWORD'] : admin_password = "adminpassword"

User.create!(name:  "admin",
             email: admin_email,
             password:              admin_password,
             password_confirmation: admin_password,
             admin: 'true',
             superadmin: 'true',
             activated: true,
             activated_at: Time.zone.now)

Goal.create!(title: "Goals")

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