# == Schema Information
# Schema version: 20100709222530
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
  acts_as_textiled :definition
end
