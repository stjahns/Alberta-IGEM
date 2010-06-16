class Glossary < ActiveRecord::Base
  acts_as_textiled :definition
end
