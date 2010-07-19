# == Schema Information
# Schema version: 20100716232236
#
# Table name: encyclopaedias
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  article    :text
#  created_at :datetime
#  updated_at :datetime
#

class Encyclopaedia < ActiveRecord::Base
  #acts_as_textiled :article
end
