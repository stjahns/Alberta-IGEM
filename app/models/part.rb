# == Schema Information
# Schema version: 20100716232236
#
# Table name: parts
#
#  id           :integer(4)      not null, primary key
#  construct_id :integer(4)
#  bio_byte_id  :integer(4)
#  part_order   :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Part < ActiveRecord::Base
  belongs_to :construct
  belongs_to :bio_byte



end
