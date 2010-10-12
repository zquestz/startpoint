# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Helper to track time easily.
def time
  start = Time.now
  yield
  Time.now - start
end

# Initial message
puts "^!^ Seeding data into our fresh rails app.\n\n"

# Create initial admin user.
user_time = time do
  puts "^!^ Creating admin user..."
  user = User.create(
    :first_name => 'Admin', 
    :last_name => 'User', 
    :login => 'admin', 
    :email => Setting.admin_email, 
    :password => 'administrator', 
    :password_confirmation => 'administrator'
  )
  File.open(RAILS_ROOT + "/public/images/seeds/admin.png", 'r') do |f|
    user.avatar = f
  end
  user.activate
  user.upgrade_to_admin!
end
puts "Done in #{user_time} seconds.\n\n"

# Create homepage
user_time = time do
  puts "^!^ Creating homepage..."
  page = Page.create(:name => 'Homepage', :protected => true)
  page.save
end
puts "Done in #{user_time} seconds.\n\n"

# Create contact page
user_time = time do
  puts "^!^ Creating contact page..."
  page = Page.create(:name => 'Contact', :protected => true)
  page.save
end
puts "Done in #{user_time} seconds.\n\n"

# Create admin page
user_time = time do
  puts "^!^ Creating admin page..."
  page = Page.create(:name => 'Admin', :content => '<p>Welcome to the admin area.</p>', :protected => true)
  page.save
end
puts "Done in #{user_time} seconds.\n\n"

# Create a bunch of users.
# Requires ENV['TESTDATA']
if ENV['TESTDATA']
  user_time = time do
    puts "^!^ Creating regular users for testing..."
    (1..10000).each do |i|
      user = User.create(:first_name => 'Regular', :last_name => 'User', :login => 'user' + i.to_s, :email => 'user' + i.to_s + '@user.com', :password => 'regularuser', :password_confirmation => 'regularuser')
      user.activate!
    end
  end
  puts "Done in #{user_time} seconds.\n\n"
end