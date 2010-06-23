# == Schema Information
# Schema version: 20100622212548
#
# Table name: glossaries
#
#  id         :integer(4)      not null, primary key
#  term       :string(255)
#  definition :text
#  created_at :datetime
#  updated_at :datetime
#

class Glossary < ActiveRecord::Base
end
