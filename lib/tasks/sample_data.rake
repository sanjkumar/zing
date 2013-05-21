namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(username: "Example User",
                 email: "example@zing.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      username  = Faker::Username.username
      email = "example-#{n+1}@zing.com"
      password  = "password"
      User.create!(username: usename,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 6)
      50.times do
        content = Faker::Lorem.sentence(5)
        users.each { |user| user.posts.create!(content: content) }
      end
    end

end