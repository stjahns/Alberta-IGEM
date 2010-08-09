class GroupsController < ApplicationController
  before_filter :set_nav
  before_filter :login_required, :except => [:index,:show]

  before_filter :not_in_group, :only => [:join, :request_to_join, :join_with_key]

  def index
	@groups = Group.all
  end

  def show
	@group = get_group_by_id_or_name
	@members = @group.users
	@messages = @group.messages.all(:order=>"created_at DESC")
	@requests = @group.requests.all
  end

  def new
	  @group = Group.new
  end

  def destroy
	  @group = Group.find(params[:id])
	  @group.destroy

	  redirect_to( groups_path )
  end

  def create
	  #@group = Group.new( params[:group] )
	  @group = current_user.create_new_group( params[:group] )
	  unless @group.nil?
	  
		  # assign creater to admin_role of group
		  #current_user.group = @group
		  #current_user.role = @group.admin_role
		  
		  #if current_user.save
			flash[:notice] = 'The group was succesfully created.'
			#redirect_to pretty_group_path( @group.name )
			redirect_to group_path( @group )
		  #else
		#	flash[:error] = 'There was an error creating the group.'
		 # end
	  else
		  flash[:error] = 'The group could not be created!'
		  redirect_to groups_path
	  end

  end

  def edit
	  @group = get_group_by_id_or_name
  end

  def update 
	  @group = Group.find(params[:id])
	  respond_to do |format|
		  if @group.update_attributes( params[:group] )
			format.html { 	flash[:notice] = 'Group info updated.'
					redirect_to @group}
			format.js {	render :partial=>'info' }

		  else
			format.html { 	flash[:error] = 'The changes were not saved'
					redirect_to @group}
			format.js   {  	head :bad }
		  end
	  end
  end

  def join
	  @group = Group.find(params[:id])
	  @request = Request.new
  end

  def join_with_key
	  @group = Group.find(params[:id])
	  
	  respond_to do |format|
	    if @group.join_with_key( current_user, params[:key] )
		format.html {
		       	flash[:notice] =  "Succesfully joined #{@group.name}."
			redirect_to group_path(@group)
		}
		format.js { head :ok }
	    else
		format.html {
			flash[:error] = "Incorrect key, could not join #{@group.name}"
			redirect_to join_group_path(@group)

		}
		format.js { head 'incorrect key'}
	    end
	  end
  end
  def request_to_join
	  @group = Group.find(params[:id])
	  request = params[:request]

	  respond_to do |format|

		  if @group.request_to_join current_user, request[:message]
		  format.html {
			  flash[:notice] = "Request to join the group #{@group.name} was sent."
			 redirect_to group_path(@group) 
		  }
		  else
			  format.html {
				  flash[:error] = "There was an error sending the request to join the group #{@group.name}."
				  redirect_to group_path(@group)
			  }
		  end

	  end
	  
  end
  def quit
	@group = Group.find(params[:id])

	if current_user.groups.delete( @group )
		flash[:notice] = "#{current_user.login} has left #{@group.name}"
		redirect_to profile_path( current_user.login )	
	else
		falsh[:error] = "error leaving #{@group.name}"
		redirect_to profile_path( current_user.login )	
	end



  end

  def new_key 
	@group = Group.find(params[:id])
	
	key = @group.generate_new_key
	if key
		render :text=>key
	else
		head :error
	end

  end

  def kick_out
	@group = Group.find(params[:id])
	@user = User.find( params[:user] )

	if @group.kick_out( @user )
		render :nothing
	else
		head :error
	end

  end

  def change_role
	  @group = Group.find( params[:id] )
	  @user = User.find( params[:user] )

	  if current_user.can_modify_roles_for_group?( @group ) && @group.users.exists?( @user )
	  
		  if params[:role] == "group_admin"
			worked = @group.make_member_admin @user
		  elsif params[:role] == "group_member"
			worked = @group.make_admin_member @user
		  elsif params[:role] == "ban"
			worked = @group.ban_member @user
		  elsif params[:role] == "unban"
			worked = @group.unban_member @user
		  end
	
		  respond_to do |format|
		  	if worked
				format.js { render :partial=>'groups/members', :locals=>{ :member=>@user, :group=>@group } }
				format.html { flash[:notice] = "User is now a #{@group.name_of_role_for( @user )}." 
					redirect_to group_path( @group )
				}
			else
				format.js { render :text=>"There was an error" }
				format.html { flash[:error] = "There was an error" 
					redirect_to group_path( @group )
				}
			end
		  end

	
	  else
		  flash[:error] = "You are not allowed to do that"
		  redirect_to :home 
	  end
  end

  def upload
	  @group = Group.find(params[:id])
  end
  
  private
  def set_nav
	  @navbar_selected = :groups
  end
  def  get_group_by_id_or_name
	 params[:name] ? Group.find_by_name(params[:name]) : Group.find(params[:id])
  end

  def not_in_group
	  group = Group.find(params[:id])
	  already_in_group( group ) if current_user.in_group?( group ) 
  end
  def already_in_group( group )
	flash[ :error ] = "You are already in the group #{group.name}"
	redirect_to groups_path
  end

end
