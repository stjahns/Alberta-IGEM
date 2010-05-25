# == Schema Information
# Schema version: 20100520201543
#
# Table name: steps
#
#  id            :integer(4)      not null, primary key
#  description   :text
#  title         :string(255)
#  image         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  experiment_id :integer(4)
#

class Step < ActiveRecord::Base
  attr_accessible :title, :description, :image, :experiment_id
  belongs_to :experiment
end
