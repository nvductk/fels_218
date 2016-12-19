# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "Admin",
  email: "admin@framgia.com",
  password: "admin123",
  password_confirmation: "admin123",
  is_admin: true,
  activated: true,
  activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@framgia.com"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

10.times do |n|
  category_name = "Category #{n+1}"

  category = Category.create name: category_name

  90.times do |j|
    word_content = "word #{j+1} - category #{n+1}"
    word = Word.create content: word_content,
      category_id: category.id,
      answers_attributes: {
        0 => {
          content: "answer 1 - word #{j+1}",
          is_correct: 0,
          word_id: j+1
        },
        1 => {
          content: "answer 2 - word #{j+1}",
          is_correct: 0,
          word_id: j+1
        },
        2 => {
          content: "answer 3 - word #{j+1}",
          is_correct: 0,
          word_id: j+1
        },
        3 => {
          content: "answer 4 - word #{j+1}",
          is_correct: 1,
          word_id: j+1
        }
      }
  end
end

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each {|followed| user.follow followed}
followers.each {|follower| follower.follow user}
