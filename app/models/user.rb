# == Schema Information
# Schema version: 20100726173047
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
#

require 'digest/sha1'

class User < ActiveRecord::Base
#TODO make sure that we are not querying the db with every call of permissions

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_many :experiments, :dependent => :destroy
  has_many :steps, :through => :experiments 
  has_one  :request, :dependent => :destroy
  belongs_to :role
  delegate :permissions, :to => :role
  has_and_belongs_to_many :groups

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :role, :group


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

 
  # sugary method for rbac
  # added a new way to check for permission relating to ownership
  # syntax for permission 	permission_for_own_model
  # and 			permission_for_any_model
  # ex:		edit_for_own_experiment? @experiment
  # 		edit_for_any_experiment?
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

  # need this so we can say for own user
  def user
	self
  end	
  
  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end

  private
  

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
    /^can_([a-zA-Z]\w*)_for_own_([a-zA-Z]\w+)\?$/.match(method_id.to_s)
  end


   def permission_for_own?( perm , type, object )
    # store permissions in a variable so we don't have to do more queries
    perms = []
    permissions.each{ |p| perms << p.name }

    # check if the user has the for any permission
    return true if has_perm?( perms,  perm + "_for_any_" + type )
    return false unless has_perm?( perms, perm + "_for_own_" + type )

    # check if the user owns the objects by looking for association
    if check_for_method object, "users"
    # object has many users
      return object.users.exists? self

    elsif check_for_method object, "user"
    # object has one user
      return object.user == self
    end
    
    #type = object.class.to_s.downcase
    if check_for_method self, type.pluralize
    # user has_many objects
      return self.send( type.pluralize.to_sym ).exists?( object )
    elsif check_for_method self, type
    # user has_one object
      return self.send( type.to_sym ) == object
    end
  
    # should not have called this method if we get to here 
    false
   end  

   def has_perm?(perms, query)
	   perms.select{ |i| i =~ /^#{query}$/ }.length > 0
   end

   def check_for_method( object, method )
	    object.methods.select{|i| i =~ /^#{method}$/}.length > 0
   end

end
