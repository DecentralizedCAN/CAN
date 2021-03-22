# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Setting.create!(id: 1, title: "Allow any member to post", state: false)
Setting.create!(id: 2, title: "Limit multiple posts within a short amount of time", state: false)
Setting.create!(id: 3, title: "Allow users to sign up on their own", state: false)
Setting.create!(id: 4, title: "Include a discussion section for brainstorms", state: false)
Setting.create!(id: 5, title: "Include a discussion section for actions", state: false)
Setting.create!(id: 6, title: "Make content viewable without an account", state: false)
Setting.create!(id: 7, title: "Require new members to provide an email address", state: false)
Setting.create!(id: 8, title: "Allow users to receive emails (reduced security)", state: false)
Setting.create!(id: 9, title: "Hide proposal participation and default to 1", state: false)
Setting.create!(id: 10, title: "Allow facilitator mode", state: false)
Setting.create!(id: 11, title: "Allow multiple scoring methods", state: false)
Setting.create!(id: 12, title: "Allow anyone to broadcast new posts", state: false)
Setting.create!(id: 13, title: "Allow new goals to be posted to the feed", state: false)
Setting.create!(id: 14, title: "Enable dashboard", state: false)

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

Goal.create!(title: "Top")

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