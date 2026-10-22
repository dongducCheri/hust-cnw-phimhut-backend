puts "Seeding users..."
admin = User.find_or_initialize_by(email: "admin@phimhut.com")
admin.update!(
  name: "Admin PhimHut",
  password: "password123",
  password_confirmation: "password123",
  role: :admin,
  balance: 1_000_000,
  is_locked: false
)
user = User.find_or_initialize_by(email: "dongxuanduc2005@gmail.com")
user.update!(
  name: "Duc Dong",
  password: "54321cc",
  password_confirmation: "54321cc",
  role: :user,
  balance: 50_000,
  is_locked: false
)
puts "Done! Created #{User.count} users:"
puts "- Admin: #{admin.email} / password123 (role: #{admin.role})"
puts "- User:  #{user.email} / 54321cc (role: #{user.role})"