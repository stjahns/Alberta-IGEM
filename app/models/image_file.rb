class ImageFile < ActiveRecord::Base
  #make steps controller work with fleximage
  class Photo < ActiveRecord::Base
    acts_as_fleximage :image_directory => 'public/images'
  end

#  def self.save(upload)
#    name =  upload.original_filename
#    directory = "public/images"
#    # create the file path
#    path = File.join(directory, name)
#    # write the file
#    File.open(path, "wb") { |f| f.write(upload.read) }
#    return name
#  end
end
