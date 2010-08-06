# == Schema Information
# Schema version: 20100806052151
#
# Table name: permissions
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles
end
