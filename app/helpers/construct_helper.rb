module ConstructHelper

  
  def can_modify(construct)
    if current_user
      if current_user.login == construct.author or 
         current_user.login == "admin"
         return true
      end
    end
    return false
  end



end
