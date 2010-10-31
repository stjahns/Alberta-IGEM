# == Schema Information
# Schema version: 20100819165030
#
# Table name: experiments
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  authour     :string(255)
#  description :text
#  published   :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer(4)
#  group_id    :integer(4)
#  status      :string(255)
#

class Experiment < ActiveRecord::Base
  attr_accessible :title, :authour, :description, :published, :image, :user_id, :status, :temp
  has_many :steps, :dependent => :destroy  
  has_many :constructs, :dependent => :destroy
  has_many :notes, :through => :steps
  belongs_to :user

   #after_create :status_none 
   #TODO do we want to kill all this status stuff?
   
  # pagination stuff
  cattr_reader :per_page
  @@per_page = 10

  def self.search(search,page)
	paginate :per_page => 10, :page => page,
		:conditions => ['published = ? AND ( description like ? OR title like ? )', true , "%#{search}%", "%#{search}%" ],:order => 'title'

  end

  def clone_experiment_for( user )
    
    # user object has to be passed in because model does not have access to
    #  session info
    
    # assign the current user's info to the cloned experiment
    new_experiment = self.clone
    new_experiment.user_id = user.id
    new_experiment.authour = user.login
    new_experiment.published = false
    new_experiment.status_none 
    new_experiment.save


    i = 1
    self.steps.all(:order => :step_order).each do |step|
      new_step = step.clone
      new_step.experiment = new_experiment
      new_step.save
    end


    self.constructs.each do |construct|
      new_construct = construct.clone
      new_construct.experiment = new_experiment
      new_construct.save
      construct.parts.each do |part|
        new_part = part.clone
        new_part.construct = new_construct
        new_part.save
      end
    end

    return new_experiment
  end

  def permissions_for( user )
	if user == self.user
		return Role.find_by_name("experiment_owner").permissions
	end
	return user.permissions
  end

  def status_completed
	  setStatus( "complete" )
  end
  def status_working
	  setStatus( "working" )
  end
  def status_none
	  setStatus( "none" )
  end

  def complete?
	  self.status == "complete"
  end
  def working?
	  self.status == "working"
  end 


  private
  def setStatus( new_status )
	  u = self.user
	  if( self.status == "working" )
		  u.working_counter  -= 1 if( new_status != "working" )
		  u.complete_counter += 1 if( new_status == "complete")
	  elsif( self.status == "complete" )
		  u.complete_counter -= 1 if( new_status != "complete")
		  u.working_counter  += 1 if( new_status == "working" )
	  end
	  self.status = new_status
	  self.save && u.save 
  end
 

end

