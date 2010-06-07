module StepsHelper
  def self.show_image
     directory = 'public/images'
     name      =  self.image
     path      =  File.join(directory , name)
      
  end
end

