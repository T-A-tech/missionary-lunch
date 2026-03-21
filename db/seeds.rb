# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin_email = ENV.fetch("ADMIN_EMAIL", "admin@almoco.com")
admin_name  = ENV.fetch("ADMIN_NAME", "Admin")
admin_pass  = ENV.fetch("ADMIN_PASSWORD", "changeme123")
admin_stake = ENV.fetch("ADMIN_STAKE", "Estaca Padrão")
admin_ward  = ENV.fetch("ADMIN_WARD", "Ala Padrão")

user = User.find_or_create_by!(email: admin_email.downcase) do |u|
  u.name = admin_name
  u.password = admin_pass
  u.password_confirmation = admin_pass
end

unless user.ward
  stake = Stake.find_or_create_by!(name: admin_stake)
  Ward.create!(user: user, stake: stake, name: admin_ward)
  puts "Admin ward created: #{admin_ward} - #{admin_stake}"
end
