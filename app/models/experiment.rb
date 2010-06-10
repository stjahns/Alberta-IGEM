# == Schema Information
# Schema version: 20100609172527
#
# Table name: experiments
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  authour     :string(255)
#  description :text
#  published   :boolean(1)
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Experiment < ActiveRecord::Base
  attr_accessible :title, :authour, :description, :published, :image
  has_many :steps, :dependent => :destroy  
  has_many :constructs, :dependent => :destroy


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

end

