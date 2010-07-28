# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

#create permissions
=begin
delete_experiments=Permission.create!(:name => 'delete_experiments',
                  :description => "Allowed to delete any experiment")
delete_group_users=Permission.create!(:name => 'delete_group_users',
                  :description => "Allowed to delete any user in their user group")
create_groups=Permission.create!(:name => 'create_groups',
                  :description => "Allowed to create user groups.")
edit_experiments=Permission.create!(:name => 'edit_experiments',
                  :description => "Allowed to edit any experiment")
ban_users=Permission.create!(:name => 'ban_users',
                  :description => "Allowed to ban any user")
probate_users=Permission.create!(:name => 'probate_users',
                  :description => "Allowed to probate any user")
delete_groups=Permission.create!(:name => 'delete_groups',
                  :description => "Allowed to delete any group")
add_users_to_groups=Permission.create!(:name => 'add_user_to_groups',
                  :description => "Allowed to add any user to any group")
remove_users_from_groups=Permission.create!(:name => 'remove_users_from_groups',
                  :description => "Allowed to remove any user from any group")
create_group_experiments=Permission.create!(:name => 'create_group_experiments',
                  :description => "Allowed to create experiments for users in their own groups")
edit_group_experiments=Permission.create!(:name => 'edit_group_experiments',
                  :description => "Allowed to edit experiments (that are associated with the group) for users in their group.")
delete_group_experiments=Permission.create!(:name => 'delete_group_experiments',
                  :description => "Allowed to delete experiments (that are associated with the group) for users in their group.")
make_comments=Permission.create!(:name => 'make_comments',
                  :description => "Can comment on anything")
create_experiments=Permission.create!(:name => 'create_experiments',
                  :description => "Can create experiments for anyone")
create_group_experiments=Permission.create!(:name => 'create_experiments',
                  :description => "Can create experiments for anyone in their group they administer")
create_own_experiments=Permission.create!(:name => 'create_experiments',
                  :description => "Can create experiments for themselves")
delete_own_experiments=Permission.create!(:name => 'delete_own_experiments',
                  :description => "Can delete their own experiments")
edit_own_experiments=Permission.create!(:name => 'edit_own_experiments',
                  :description => "Can edit their own experiments")
=end

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

# permission added by mike
# 

# permissions for changing user info
change_user_info_for_own_user=Permission.create!(
	:name=>"change_user_info_for_own_user", 
	:description=>"Can change own info")
change_user_info_for_any_user=Permission.create!(
	:name=>"change_user_info_for_any_user", 
	:description=>"Can change any user info")

# permissions for editing experments
create_experiment_for_own_user=Permission.create!(
	:name=>"create_experiment_for_own_user", 
	:description=>"Can create new experiments in lab-book")
edit_experiments_for_own_group=Permission.create!(
	:name=>"edit_experiments_for_own_group", 
	:description=>"Can edit experiment for any user in group")
edit_for_own_experiment=Permission.create!(
	:name=>"edit_for_own_experiment", 
	:description=>"Can edit own experiments")
edit_for_any_experiment=Permission.create!(
	:name=>"edit_for_any_experiment",
	:description=>"Can edit any experiments")
delete_experiments_for_own_group=Permission.create!(
	:name=>"delete_experiments_for_own_group", 
	:description=>"Can delete experiment for any user in group")
delete_for_own_experiment=Permission.create!(
	:name=>"delete_for_own_experiment", 
	:description=>"Can delete own experiments")
delete_for_any_experiment=Permission.create!(
	:name=>"delete_for_any_experiment",
	:description=>"Can delete any experiments")

# permissions for group attributes
quit_for_own_group=Permission.create!(:name=>'quit_for_own_group',
		  :description =>"Allowed to quit own group")
delete_for_own_group=Permission.create!(:name => 'create_groups',
                  :description => "Allowed to delete own group.")
delete_for_any_group=Permission.create(:name => 'delete_for_any_group',
		  :description => "Allowed to delete any groups." )
ban_users_for_own_group=Permission.create!(:name=>'ban_users_for_own_group',
		  :description=>'Ban user from own group')
ban_users_for_any_group=Permission.create!(:name => 'ban_users_for_any_group',
                  :description => "Allowed to ban any user")
probate_users_for_own_group=Permission.create!(
		  :name => 'probate_users_for_own_group',
                  :description => "Allowed to probate users in group")
probate_users_for_any_group=Permission.create!(
		  :name => 'probate_users_for_any_group',
                  :description => "Allowed to probate any user")
accept_requests_for_own_group=Permission.create!(
	:name => 'accept_requests_for_own_group',
        :description => "Allowed to accept requests to join own group")
accept_requests_for_any_group=Permission.create!(
	:name => 'accept_requests_for_any_group',
        :description => "Allowed to accept requests to join any group")
remove_users_for_own_group=Permission.create!(
	:name => 'remove_users_for_own_group',
        :description => "Allowed to remove any user from own group")
remove_users_for_any_group=Permission.create!(
	:name => 'remove_users_for_any_group',
        :description => "Allowed to remove any user from any group")

	
#create roles
admin_role=Role.create!(:name => 'admin', 
                :description => "Primary administrator role",
                :permissions => [
                                 create_bio_bytes,
                                 edit_bio_bytes,
                                 delete_users,
				 edit_step_generators,
=begin
# permissions mike replaced
				 delete_experiments,
                                 edit_experiments,
                                 ban_users,
                                 probate_users,
                                 delete_groups,
                                 add_users_to_groups,
                                 remove_users_from_groups,
                                 create_experiments,
				 edit_any_user_info,
=end
				 # added by mike
				 create_experiment_for_own_user,
				 change_user_info_for_any_user,
				 edit_for_any_experiment,
				 delete_for_any_experiment,
				 ban_users_for_any_group,
				 probate_users_for_any_group,
				 accept_requests_for_any_group,
				 remove_users_for_any_group,
				 delete_for_any_group,
                                 create_groups,
				 quit_for_own_group


                                ])

group_admin_role=Role.create!(:name => 'group_admin', 
                :description => "Group administrator role",
                :permissions => [
				 change_user_info_for_own_user,
                                 edit_experiments_for_own_group,
				 delete_experiments_for_own_group,
				 delete_for_own_group,
				 ban_users_for_own_group,
				 probate_users_for_own_group,
				 accept_requests_for_own_group,
				 remove_users_for_own_group,
				 quit_for_own_group,
=begin old perms
				 delete_group_users,
                                 delete_group_experiments,
                                 edit_group_experiments,
                                 create_group_experiments,
                                 make_comments,
                                 create_groups,
                                 delete_groups,
                                 add_users_to_groups,
                                 remove_users_from_groups,
                                  #include default perm's as well?
				 #should they be able to change users info
=end
				])

default_role=Role.create!(:name => 'default', 
                :description => "Default user role, can do basic stuff like create and do experiments and whatnot",
                :permissions => [
                                #create_experiments,
                                #delete_own_experiments,
                                #edit_own_experiments,
				quit_for_own_group,
				create_experiment_for_own_user,
				delete_for_own_experiment,
				edit_for_own_experiment
                                ])

moderator_role=Role.create!(:name => 'moderator',
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
                            

banned_role=Role.create!(:name => 'banned', 
                :description => "Banned user role",
                :permissions => [
                                # Pretty much **** all
                                ])

probated_role=Role.create!(:name => 'probated', 
                :description => "Probated user role",
                :permissions => [
                                # Pretty much **** all
                                ])

=begin Temporarily comment everything out but roles

#create an admin user
admin_user=User.create!(:login => 'admin', 
            :role_id => admin_role.id,
            :email => 'genomikon@gmail.com',
            :password => 'password',
            :password_confirmation => 'password')
admin_user.role = admin_role # can't mass assign
admin_user.save
#----- NB - still need to activate through the email
           
#-----------------------------------------------
# Biobyte sample seeds
gfp = ORF.create!(:name => 'GFP Cassette', 
                 :description => 'Green fluorescent protein ORF cassette',
                 :sequence => 'CCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGCGATCACGACTCCCAGTCATGCGGATCACGACTCCCAGTCATGCG'
                 )
promoter = Linker.create!(:name => 'Promoter Cassette', 
                 :description => 'Lac promoter, inducible with IPTG, Lactose, inihibited by glucose',
                 :sequence => 'CCGTCGGCGGACAACACGTACTGACCGTCGGCGGACAACACGTACTGACCGTCGGCGGACAACACGTACTGACCGTCGGCGGACAACACGTACTGACCGTCGGCGGACAACACGTACTGACCGTCGGCGGACAACACGTACTGACCGTCGGCGGACAACACGTACTGACCGTCGGCGGACAACACGTACTGACGTCGGCGGACAACACGTACTGAC'
                 )

#------------------------------------------------
# Step Generator template seeds

step1 = StepGenerator.create!(:subprotocol => "assembly prep", 
                              :sub_order => 1,
                              :title => "Steps prior to part addition to 'construct'",
                              :description => "Description of step"
                             ) 

step2 = StepGenerator.create!(:subprotocol => "part addition", 
                              :sub_order => 1,
                              :title => "Step to add 'part' to 'construct'",
                              :description => "Description of step"
                             ) 
               
step3 = StepGenerator.create!(:subprotocol => "assembly completion", 
                              :sub_order => 1,
                              :title => "Steps after adding parts to 'construct'",
                              :description => "Description of step"
                             )

#------------------------------------------------
                 
=end
