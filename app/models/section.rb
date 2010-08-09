class Section < ActiveRecord::Base
  attr_accessible :title, :description, :image, :encyclopaedia_id,
                  :section_order, :video, :caption, :video_title

  belongs_to :encyclopaedia

  has_one :image, :dependent => :destroy

  protected
      def validate
        errors.add_on_empty %w( title encyclopaedia_id section_order)
        errors.add("video_title", "must be included") unless  video.blank? || !video_title.blank?
      end

end
