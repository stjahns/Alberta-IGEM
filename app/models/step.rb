# == Schema Information
# Schema version: 20100608222653
#
# Table name: steps
#
#  id            :integer(4)      not null, primary key
#  description   :text
#  title         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  experiment_id :integer(4)
#  step_order    :integer(4)
#  image_id      :integer(4)
#

class Step < ActiveRecord::Base
  attr_accessible :title, :description, :image, :experiment_id, :order
  belongs_to :experiment
  has_one :image
end
