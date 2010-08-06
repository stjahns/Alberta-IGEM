# == Schema Information
# Schema version: 20100806052151
#
# Table name: email_observers
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  key        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer(4)
#

class EmailObserver < ActiveRecord::Base

	 belongs_to :user
	 before_create :make_key
	 after_create :email_user

	 attr_accessible :key, :email

	  validates_presence_of     :email
	  validates_length_of       :email,    :within => 6..100 #r@a.wk
	  #validates_uniqueness_of   :email
	  # need to check for already creted emails as well
	  # own validation since it is in another table
	  validates_each :email do |model, attr, value|
		model.errors.add(attr, 'is not unique!') unless User.find_by_email( value ).blank?
	  end
	  
	 
	  validates_format_of :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message



	 def make_key
		self.key = ActiveSupport::SecureRandom.base64(42) 
	 end

	 def email_user
		UserMailer.deliver_new_email_activation( self )
	 end



end
