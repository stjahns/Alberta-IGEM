# == Schema Information
# Schema version: 20100806052151
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(40)
#  name                      :string(100)     default("")
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#  group_id                  :integer(4)
#  role_id                   :integer(4)
#  reset_code                :string(255)
#  description               :text
#

require 'digest/sha1'

class User < ActiveRecord::Base
#TODO make sure that we are not querying the db with every call of permissions

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_many :experiments, :dependent => :destroy
  has_many :steps, :through => :experiments 
  has_one :email_observer, :dependent => :destroy

  belongs_to :role
  delegate :permissions, :to => :role
  
  has_many :groups, :through => :group_roles 
  has_many :group_roles
  #has_and_belongs_to_many :groups
  
  has_many :requests, :dependent => :destroy

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true

  #TODO
  validates_each :login do |record, attr, value|
	  if record =~ /[^0-9a-zA-Z]/
		  record.errors.add attr, "login must be composed of alphanumberic characters and _"
	  end
  end

  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  before_create :make_activation_code 
  before_create :give_default_role

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :role, :group, :description


  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

#reset methods

  def create_reset_code
    @reset = true
    puts "Hello world!"
    self.reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join ) 
    save(false)
  end

  def recently_reset?
    @reset
  end

  def delete_reset_code
    self.attributes = {:reset_code => nil}
    save(false)
  end

  # create new email
  def create_new_email( email )
	e = self.build_email_observer( :email => email, :user=>self )
	e.save
  end

  # responds to /new_email/:key
  def activate_email( key )
	return false if self.email_observer.blank?

	if self.email_observer.key == key
		self.email = email_observer.email
		self.save
		email_observer.destroy
		true
	else
		false
	end
  end

  # need this so we can say for own user
  def user
	self
  end	

  def in_group?(group)
	self.groups.exists?( group )
  end

  def permissions_for( user )
	# returns base role permissions
	if user == self
		return	Role.find_by_name('own_user').permissions
	else
		return user.permissions
	end
  end 

  def create_new_group( params )
	# create a new group and assign the user
	# to the group_admin role
	g = Group.create( params )
	r = g.create_admin( self )
	g
  end

 
  # sugary method for rbac
  # added a new way to check for permission relating to ownership
  # syntax for permission 	permission_for_model
  # ex:		edit_for_experiment? @experiment
  # the type needs to be singular
  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      tokenize_roles(match.captures.first).each do |check|
        return true if role.name.downcase == check
      end
      return false
    # adding a case to check if the user has a for_own or for_any permission
    elsif match = matches_dynamic_perm_for_own_check?(method_id)
      return permission_for_own?( match[1], match[2], args[0] ) 

    elsif match = matches_dynamic_perm_check?(method_id)
      if permissions.find_by_name(match.captures.first)
        return true
      else
        return false
      end
    else
      super
    end
  end

  def experiments_completed
	self.experiments.find_all_by_status( "complete" ).length
  end
  def experiments_working
	self.experiments.find_all_by_status( "working" ).length
  end

  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end

  private

  def give_default_role
	self.role = Role.find_by_name( "default" )
  end
  

  def matches_dynamic_role_check?(method_id)
    /^is_an?_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

  def tokenize_roles(string_to_split)
    string_to_split.split(/_or_/)
  end

  def matches_dynamic_perm_check?(method_id)
    /^can_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

  def matches_dynamic_perm_for_own_check?(method_id)
    /^can_([a-zA-Z]\w*)_for_([a-zA-Z]\w+)\?$/.match(method_id.to_s)
  end


   def permission_for_own?( perm , type, object )
    # check for permissions related to that object
    # ownership is controlled by the premissions_for method in a model
    # object.permissions_for( user ) must decide what role user has in
    # relation to that object and return permissions for it
    # for example the experiments model checks if the user created the
    # experiment and returns permissions for the Role experiment_owner
    # if they are the creater

    # check for permission
    perm_name = perm + "_for_" + type
    # check users base permissions if we don't find the 
    # permission there check the object specific permissions
    user.permissions.find_by_name( perm_name ) ||
	 object.permissions_for( self ).find_by_name( perm_name )

   end  


end
