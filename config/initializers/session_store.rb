# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_startpoint_session',
  :secret      => '38d5d40a4c4c55f0293e6220f454a343b508dcfd000e29812377dec98ec1c4712aa2a02ac37316e99891f429f33503684ff44206af9288454293dee2665dbe68'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

ActionController::Dispatcher.middleware.insert_before(
  ActionController::Session::CookieStore, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key]
)