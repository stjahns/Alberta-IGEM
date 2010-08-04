#create permissions

# permissions that should that do not depend on ownership
create_bio_bytes=Permission.find_or_create_by_name("create_bio_bytes")
create_bio_bytes.update_attributes(:description => "Allowed to create new bio bytes in the database")

edit_bio_bytes=Permission.find_or_create_by_name("edit_bio_bytes")
edit_bio_bytes.update_attributes(:description => "Allowed to edit the bio byte database")

edit_step_generators=Permission.find_or_create_by_name("edit_step_generators")
edit_step_generators.update_attributes(:description => "Allowed to edit the step generator database")

delete_users=Permission.find_or_create_by_name("delete_users")
delete_users.update_attributes(:description => "Allowed to delete any user")

create_groups=Permission.find_or_create_by_name("create_groups")
create_groups.update_attributes(:description => "Allowed to create user groups.")


# permissions for user 
change_info_for_user=Permission.find_or_create_by_name("change_info_for_user")
change_info_for_user.update_attributes(
		:description=>"Can change own info")


# permissions for editing experments
create_experiment_for_user=Permission.find_or_create_by_name("create_experiment_for_user")
create_experiment_for_user.update_attributes(
		:description=>"Can create new experiments in lab-book")

edit_experiments_for_group=Permission.find_or_create_by_name("edit_experiments_for_group")
edit_experiments_for_group.update_attributes(
		:description=>"Can edit experiment for any user in group")

edit_for_experiment=Permission.find_or_create_by_name("edit_for_experiment")
edit_for_experiment.update_attributes(
		:description=>"Can edit own experiments")

delete_experiments_for_group=Permission.find_or_create_by_name("delete_experiments_for_group")
delete_experiments_for_group.update_attributes(
		:description=>"Can delete experiment for any user in group")

delete_for_experiment=Permission.find_or_create_by_name("delete_for_experiment")
delete_for_experiment.update_attributes(
		:description=>"Can delete own experiments")

publish_for_experiment=Permission.find_or_create_by_name("publish_for_experiment")
publish_for_experiment.update_attributes(
		:description=>"Can publish experiments")


# permissions for group attributes
change_info_for_group=Permission.find_or_create_by_name("change_info_for_group")
change_info_for_group.update_attributes(:description=>"Allowed to change some or all info for group")

change_key_for_group=Permission.find_or_create_by_name("change_key_for_group")
change_key_for_group.update_attributes(:description=>'Can change key for own group')

quit_for_group=Permission.find_or_create_by_name("quit_for_group")
quit_for_group.update_attributes(:description =>"Allowed to quit own group")

delete_for_group=Permission.find_or_create_by_name("create_groups")
delete_for_group.update_attributes(:description => "Allowed to delete own group.")

ban_users_for_group=Permission.find_or_create_by_name("ban_users_for_group")
ban_users_for_group.update_attributes(:description=>'Ban user from own group')

probate_users_for_group=Permission.find_or_create_by_name("probate_users_for_group")
probate_users_for_group.update_attributes(
		:description => "Allowed to probate users in group")

modify_roles_for_group=Permission.find_or_create_by_name("modify_roles_for_group")
modify_roles_for_group.update_attributes(:description=>'Change the roles of a group member (ex: banned, admin, member)' )

accept_requests_for_group=Permission.find_or_create_by_name("accept_requests_for_group")
accept_requests_for_group.update_attributes(
		:description => "Allowed to accept requests to join own group")

remove_users_for_group=Permission.find_or_create_by_name("remove_users_for_group")
remove_users_for_group.update_attributes(
		:description => "Allowed to remove any user from own group")

delete_messages_for_group=Permission.find_or_create_by_name("delete_messages_for_group")
delete_messages_for_group.update_attributes(
		:description => "Allowed to delete own group")

send_messages_for_group=Permission.find_or_create_by_name("send_messages_for_group")
send_messages_for_group.update_attributes(
		:description => "Allowed to delete own group")

	

	
	
#create base roles
#a permission_for_object in a base role will work for any object
admin_role=Role.find_or_create_by_name('admin')
admin_role.update_attributes(
                :description => "primary administrator",
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
				 change_info_for_group,
				 modify_roles_for_group,
				 delete_messages_for_group,
				 send_messages_for_group


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
                :description => "group administrator",
                :permissions => [
				

			         modify_roles_for_group,
 		       		 change_info_for_group,
				 edit_experiments_for_group,
				 delete_experiments_for_group,
				 delete_for_group,
				 ban_users_for_group,
				 probate_users_for_group,
				 accept_requests_for_group,
				 remove_users_for_group,
				 quit_for_group,
				 delete_messages_for_group,
				 send_messages_for_group


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
                :description => "moderator",
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
group_member_role.update_attributes(
	:description => "group member",
	:permissions => [
])

                           

banned_role=Role.find_or_create_by_name('banned') 
banned_role.update_attributes(
                :description => "Banned",
                :permissions => [
                                # Pretty much **** all
                                ])

probated_role=Role.find_or_create_by_name('probated')
probated_role.update_attributes(
                :description => "Probated user role",
                :permissions => [
                                # Pretty much **** all
                                ])


