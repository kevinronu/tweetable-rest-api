puts "Seeding - START"

Like.destroy_all
Tweet.destroy_all
User.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!('likes')
ActiveRecord::Base.connection.reset_pk_sequence!('tweets')
ActiveRecord::Base.connection.reset_pk_sequence!('users')

puts "Seeding users"

admin = User.create(username: "admin", name: "Son Goku", email: "admin@mail.com", password: "supersecret", password_confirmation: "supersecret", role: "admin")
admin.avatar.attach(io: File.open('public/images/goku.webp'), filename: 'goku.webp')

thanos = User.create(username: "thanos", name: "The Great Thanos", email: "thanos@mail.com", password: "qwerty", password_confirmation: "qwerty", role: "member")
thanos.avatar.attach(io: File.open('public/images/thanos.webp'), filename: 'thanos.webp')
dr_real_neil = User.create(username: "drRealNeil", name: "The Real Neil", email: "drrealneil@mail.com", password: "qwerty", password_confirmation: "qwerty", role: "member")
dr_real_neil.avatar.attach(io: File.open('public/images/dr_real_neil.webp'), filename: 'dr_real_neil.webp')
dog_fire = User.create(username: "dogfire", name: "House on Fire", email: "dogfire@mail.com", password: "qwerty", password_confirmation: "qwerty", role: "member")
dog_fire.avatar.attach(io: File.open('public/images/dog_fire.webp'), filename: 'dog_fire.webp')
kevin = User.create(username: "kevinrn", name: "Kevin Robles", email: "kevinrn@mail.com", password: "qwerty", password_confirmation: "qwerty", role: "member")
kevin.avatar.attach(io: File.open('public/images/kevin.webp'), filename: 'kevin.webp')

puts "Seeding tweets"

tweet1 = Tweet.create(body: "I'm the admin", user: admin)
tweet2 = Tweet.create(body: "This universe is finite, its resources, finite… if life is left unchecked, life will cease to exist.", user_id: 2)
tweet3 = Tweet.create(body: "For me, I am driven by two main philosophies: know more today about the world than I knew yesterday and lessen the suffering of others.", user_id: 3)
tweet4 = Tweet.create(body: "This is fine, everything is fine.", user_id: 4)
tweet5 = Tweet.create(body: "This is my first tweet", user_id: 5)

puts "Seeding reply tweets"

tweet6 = Tweet.create(body: "I'm inevitable", user_id: 2, replied_to_id: 1)
tweet7 = Tweet.create(body: "I disagree", user_id: 5, replied_to_id: 2)
tweet8 = Tweet.create(body: "I concur", user_id: 4, replied_to_id: 3)
tweet9 = Tweet.create(body: "Don't worry", user_id: 3, replied_to_id: 4)
tweet10 = Tweet.create(body: "Nice!", user_id: 1, replied_to_id: 5)
tweet11 = Tweet.create(body: "I'm a user", user_id: 5, replied_to_id: 1)

puts "Seeding likes"

like2 = Like.create(user_id: 2, tweet_id: 1)
like4 = Like.create(user_id: 3, tweet_id: 1)
like5 = Like.create(user_id: 4, tweet_id: 1)
like6 = Like.create(user_id: 5, tweet_id: 1)
like7 = Like.create(user_id: 1, tweet_id: 2)
like8 = Like.create(user_id: 2, tweet_id: 3)
like9 = Like.create(user_id: 3, tweet_id: 4)
like10 = Like.create(user_id: 4, tweet_id: 5)
