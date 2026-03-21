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

unless User.exists?(email: admin_email.downcase)
  User.create!(
    name: admin_name,
    email: admin_email,
    password: admin_pass,
    password_confirmation: admin_pass
  )
  puts "Admin user created: #{admin_email}"
end
