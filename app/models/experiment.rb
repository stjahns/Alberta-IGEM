# == Schema Information
# Schema version: 20100519212344
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
  # associations
  has_many :steps, :dependent => :destroy

  # accesors
  attr_accessible :title, :authour, :description, :published, :image

  # Experiments are initialized as draft before 
  # they are ready to be published  
  def publish 
    @published = true
  end
end
