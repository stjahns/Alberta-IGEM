# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Alberta-IGEM_session',
  :secret      => '89990fea6fa7009cfe39c6266575066f169af6abf04cf15adf7fa9759d64f25ac7f9dc7c8833ba5dad081c2644a779a461ed741552405c81c71cc8ac9cd0ee9c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
