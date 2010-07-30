#create permissions

# permissions that should that do not depend on ownership
create_bio_bytes=Permission.create!(:name => 'create_bio_bytes',
                  :description => "Allowed to create new bio bytes in the database")
edit_bio_bytes=Permission.create!(:name => 'edit_bio_bytes',
                  :description => "Allowed to edit the bio byte database")
edit_step_generators=Permission.create!(:name => 'edit_step_generators',
                  :description => "Allowed to edit the step generator database")
delete_users=Permission.create!(:name => 'delete_users',
                  :description => "Allowed to delete any user")
create_groups=Permission.create!(:name => 'create_groups',
                  :description => "Allowed to create user groups.")

# permissions for user 
change_info_for_user=Permission.create!(
	:name=>"change_info_for_user", 
	:description=>"Can change own info")

# permissions for editing experments
create_experiment_for_user=Permission.create!(
	:name=>"create_experiment_for_user", 
	:description=>"Can create new experiments in lab-book")
edit_experiments_for_group=Permission.create!(
	:name=>"edit_experiments_for_group", 
	:description=>"Can edit experiment for any user in group")
edit_for_experiment=Permission.create!(
	:name=>"edit_for_experiment", 
	:description=>"Can edit own experiments")
delete_experiments_for_group=Permission.create!(
	:name=>"delete_experiments_for_group", 
	:description=>"Can delete experiment for any user in group")
delete_for_experiment=Permission.create!(
	:name=>"delete_for_experiment", 
	:description=>"Can delete own experiments")
publish_for_experiment=Permission.create!(
	:name=>"publish_for_experiment",
	:description=>"Can publish experiments")

# permissions for group attributes
change_info_for_group=Permission.create!(:name=>'change_info_for_group',
	     :description=>"Allowed to change some or all info for group")
change_key_for_group=Permission.create!(:name=>'change_key_for_group',		:description=>'Can change key for own group')
quit_for_group=Permission.create!(:name=>'quit_for_group',
		  :description =>"Allowed to quit own group")
delete_for_group=Permission.create!(:name => 'create_groups',
                  :description => "Allowed to delete own group.")
ban_users_for_group=Permission.create!(:name=>'ban_users_for_group',
		  :description=>'Ban user from own group')
probate_users_for_group=Permission.create!(
		  :name => 'probate_users_for_group',
                  :description => "Allowed to probate users in group")
accept_requests_for_group=Permission.create!(
	:name => 'accept_requests_for_group',
        :description => "Allowed to accept requests to join own group")
accept_requests_for_group=Permission.create!(
	:name => 'accept_requests_for_group',
        :description => "Allowed to accept requests to join any group")
remove_users_for_group=Permission.create!(
	:name => 'remove_users_for_group',
        :description => "Allowed to remove any user from own group")

	

	
	
#create base roles
#a permission_for_object in a base role will work for any object
admin_role=Role.find_or_create_by_name('admin')
admin_role.update_attributes(
                :description => "Primary administrator role",
                :permissions => [
                                 create_bio_bytes,
                                 edit_bio_bytes,
                                 delete_users,
				 edit_step_generators,

				 create_experiment_for_user,
				 change_info_for_user,

				 edit_for_experiment,
				 delete_for_experiment,
				 publish_for_experiment,

				 create_groups,
				 ban_users_for_group,
				 probate_users_for_group,
				 accept_requests_for_group,
				 remove_users_for_group,
				 delete_for_group,
				 quit_for_group,
				 change_info_for_group

                                ])

				

default_role=Role.find_or_create_by_name('default')
default_role.update_attributes(
                :description => "Default user role, can do basic stuff like create and do experiments and whatnot",
                :permissions => [
				create_groups,
				quit_for_group,

                                ])

# object specific roles
group_admin_role=Role.find_or_create_by_name('group_admin')
group_admin_role.update_attributes( 
                :description => "Group administrator role",
                :permissions => [
				


 		       		 change_info_for_group,
				 edit_experiments_for_group,
				 delete_experiments_for_group,
				 delete_for_group,
				 ban_users_for_group,
				 probate_users_for_group,
				 accept_requests_for_group,
				 remove_users_for_group,
				 quit_for_group,

				])

experiment_owner=Role.find_or_create_by_name('experiment_owner')
experiment_owner.update_attributes(
		:description =>"user is creater of the experiment",
		:permissions => [
			delete_for_experiment,
			edit_for_experiment,
			publish_for_experiment
])

own_user=Role.find_or_create_by_name('own_user')
own_user.update_attributes(
			:description =>"permissions for modifying own data",
			:permissions => [
			create_experiment_for_user,
			change_info_for_user,
])


moderator_role=Role.find_or_create_by_name('moderator')
moderator_role.update_attributes(
                :description => "Moderator role, can ban and probate ne'er-do-wells",
                :permissions => [
=begin                                ban_users,
                                probate_users,
                                create_experiments,
                                delete_own_experiments,
                                edit_own_experiments,
                                make_comments,
=end
				])
 

group_member_role=Role.find_or_create_by_name('group_member')

                           

banned_role=Role.find_or_create_by_name('banned') 
banned_role.update_attributes(
                :description => "Banned user role",
                :permissions => [
                                # Pretty much **** all
                                ])

probated_role=Role.find_or_create_by_name('probated')
probated_role.update_attributes(
                :description => "Probated user role",
                :permissions => [
                                # Pretty much **** all
                                ])


