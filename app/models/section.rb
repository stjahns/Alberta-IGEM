# == Schema Information
# Schema version: 20101030224800
#
# Table name: sections
#
#  id               :integer(4)      not null, primary key
#  title            :string(255)
#  description      :text
#  encyclopaedia_id :integer(4)
#  section_order    :integer(4)
#  video            :text
#  created_at       :datetime
#  updated_at       :datetime
#  video_title      :text
#  caption          :text
#

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
