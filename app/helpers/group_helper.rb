module GroupHelper

	def change_role_form( group, user, new_role )
	   render :partial => 'shared/change_role' , :locals=>{:group=>group,:user=>user,:new_role=>new_role}
      
	end

	

end
