class Encyclopaedia < ActiveRecord::Base
  has_many :sections

  protected
      def validate
        errors.add_on_empty %w( title )
      end

end
