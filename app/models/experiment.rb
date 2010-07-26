# == Schema Information
# Schema version: 20100722183147
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
#

class Experiment < ActiveRecord::Base
  attr_accessible :title, :authour, :description, :published, :image, :user_id
  has_many :steps, :dependent => :destroy  
  has_many :constructs, :dependent => :destroy
  has_many :notes, :through => :steps
  belongs_to :user

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


  private
 

end

