# == Schema Information
# Schema version: 20100730041111
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
#

class Experiment < ActiveRecord::Base
  attr_accessible :title, :authour, :description, :published, :image, :user_idi, :status
  has_many :steps, :dependent => :destroy  
  has_many :constructs, :dependent => :destroy
  has_many :notes, :through => :steps
  belongs_to :user

   before_create :status_none
#  after_create :assign_owner  

  def clone_experiment_for( user )
  #TODO should this code just be in the controller? no this is the right spot
    
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
	  self.status = new_status
  end
 

end

