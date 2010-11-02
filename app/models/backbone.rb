# == Schema Information
# Schema version: 20101030224800
#
# Table name: backbones
#
#  id     :integer(4)      not null, primary key
#  name   :string(255)
#  prefix :string(255)
#  suffix :string(255)
#

class Backbone < ActiveRecord::Base
  has_many :bio_bytes
end
