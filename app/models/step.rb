# == Schema Information
# Schema version: 20100519203759
#
# Table name: steps
#
#  id          :integer(4)      not null, primary key
#  description :text
#  title       :string(255)
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Step < ActiveRecord::Base
end
