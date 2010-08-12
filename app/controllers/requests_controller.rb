class RequestsController < ApplicationController

  def destroy
	@request = Request.find(params[:id])
	# send a message to user?
	
	@request.destroy
	respond_to do |format|
		format.html { flash[:notice] = 'Request deleted'
			redirect_to profile_path( current_user )
		}	
		format.js { render :text=>'Request deleted' }
	end
  end

  def reject
	  @request = Request.find( params[:id] )
  	  user = @request.user
	  group = @request.group

	  respond_to do |format|
	  	if @request.reject
			format.js{ render :text=>"#user_#{ user.id }"}
		else
			format.js{ head :error }
		end
	  end
  end

  def accept
	@request = Request.find(params[:id])
	user = @request.user
	group = @request.group
	

	respond_to do |format|
		if @request.accept
			format.js{ render :partial=>'groups/members',:locals=>{:member=>user,:group=>group}} 
		else
			format.js{ head :error }
		end
	end

  end

end
