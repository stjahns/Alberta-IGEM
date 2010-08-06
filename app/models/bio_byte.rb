# == Schema Information
# Schema version: 20100806052151
#
# Table name: bio_bytes
#
#  id            :integer(4)      not null, primary key
#  type          :string(255)
#  name          :string(255)
#  description   :string(255)
#  sequence      :string(255)
#  author        :string(255)
#  img_file_name :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  image_id      :integer(4)
#

class BioByte < ActiveRecord::Base
  has_many :parts
  has_many :annotations
  belongs_to :image
  has_one :bio_byte_image
  belongs_to :backbone

  def icon
	#return the image object that contains the biobyte icon
	self.image
  end
  def function_image
	#return the function image 
	linker =  self.bio_byte_image || return
	linker.image  
  end
#TODO add validation
  #TODO change bio_byte_image to has_one :through association?

  def parse_validation(script_output)

    script_output = script_output.split("\n")
    puts script_output
    puts "hello!"
    refseq = script_output[0]
    charmap = script_output[1]
    obsvseq = script_output[2]
    status = script_output[3]
    changes = script_output[4]

    lastmap = 0;
    val_html = "";
    map_hash = { "Y" => "vfonly",
                 "G" => "both",
                 "B" => "vronly",
                 "!" => "mismatch",
                 "?" => "unsure" }
    unless status.include? "inequal" #if lengths refseq obsvseq equal
      val_html += "Observed Sequence:<br/>"
      seqouts = [obsvseq]
      seqouts.each do |seq|
        i=0;
        seq.each_byte do |nt|
          if lastmap == 0 
            val_html += "<span class = #{map_hash[charmap[i].chr]}>#{nt.chr}"
          elsif lastmap == charmap[i]
            val_html += "#{nt.chr}"
          else
            val_html += "</span><span class = #{map_hash[charmap[i].chr]}>#{nt.chr}"
          end
          lastmap = charmap[i]
          i+=1
        end
        #break line
        val_html += "<br/>"
      end

      val_html += "</span>"
    else #there was an error 
      val_html += status
      val_html += "<br/>Reference sequence:<br/>"
      val_html += refseq
      val_html += "<br/>Observed sequence:<br/>"
      val_html += obsvseq
      val_html += "<br/>"
    end

    unless changes.nil?
      changes = changes.split('|')
      val_html += "<br/>Mismatches:<br/>"
      changes.each do |c|
        val_html += c
        val_html += "<br/>"
      end
    end

    return val_html
  end

end
