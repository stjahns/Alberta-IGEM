class BioByte < ActiveRecord::Base
  has_many :parts
  has_many :annotations

#TODO add validation

end
