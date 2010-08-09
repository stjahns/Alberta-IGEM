# == Schema Information
# Schema version: 20100806052151
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
  has_many :sections

  protected
      def validate
        errors.add_on_empty %w( title )
      end

end
