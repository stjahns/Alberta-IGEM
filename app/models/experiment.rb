# == Schema Information
# Schema version: 20100609213516
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
#

class Experiment < ActiveRecord::Base
  attr_accessible :title, :authour, :description, :published, :image, :user_id
  has_many :steps, :dependent => :destroy  
  has_many :constructs, :dependent => :destroy
  belongs_to :users

#  after_create :assign_owner  

  def clone_experiment
  #TODO should this code just be in the controller?

    new_experiment = self.clone

    self.steps.each do |step|
      newstep = step.clone
      newstep.experiment = new_experiment
      newstep.save
    end

    self.constructs.each do |construct|
      new_construct = construct.clone
      new_construct.experiment = new_experiment
      new_construct.save
    end

    new_experiment.save

    return new_experiment

  end

  private
  
#  def assign_owner
#    self.user_id = current_user.id
#    self.save
#  end


end

