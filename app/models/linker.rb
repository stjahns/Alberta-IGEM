# == Schema Information
# Schema version: 20101030224800
#
# Table name: bio_bytes
#
#  id                    :integer(4)      not null, primary key
#  type                  :string(255)
#  name                  :string(255)
#  description           :string(255)
#  author                :string(255)
#  img_file_name         :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  image_id              :integer(4)
#  val_string            :text
#  sequence              :text
#  backbone_id           :integer(4)
#  biobrick_id           :string(255)
#  biobrick_backbone     :string(255)
#  biobyte_id            :string(255)
#  biobyte_plasmid       :string(255)
#  function_verification :text
#  comments              :text
#  vf_uploaded           :boolean(1)
#  vr_uploaded           :boolean(1)
#  category_id           :integer(4)
#

class Linker < BioByte
end
