# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

#create permissions
create_bio_bytes=Permission.create!(:name => 'create_bio_bytes',
                  :description => "Allowed to create new bio bytes in the database")
edit_bio_bytes=Permission.create!(:name => 'edit_bio_bytes',
                  :description => "Allowed to edit the bio byte database")
edit_step_generators=Permission.create!(:name => 'edit_step_generators',
                  :description => "Allowed to edit the step generator database")
delete_users=Permission.create!(:name => 'delete_users',
                  :description => "Allowed to delete any user")
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




#create roles
admin_role=Role.create!(:name => 'admin', 
                :description => "Primary administrator role",
                :permissions => [
                                 create_bio_bytes,
                                 edit_bio_bytes,
                                 delete_users,
                                 delete_experiments,
                                 edit_experiments,
                                 ban_users,
                                 probate_users,
                                 create_groups,
                                 delete_groups,
                                 add_users_to_groups,
                                 remove_users_from_groups,
                                 create_experiments,
                                ])

group_admin_role=Role.create!(:name => 'group_admin', 
                :description => "Group administrator role",
                :permissions => [
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
                                ])

default_role=Role.create!(:name => 'default', 
                :description => "Default user role, can do basic stuff like create and do experiments and whatnot",
                :permissions => [
                                create_experiments,
                                delete_own_experiments,
                                edit_own_experiments,
                                make_comments,
                                ])

moderator_role=Role.create!(:name => 'moderator',
                :description => "Moderator role, can ban and probate ne'er-do-wells",
                :permissions => [
                                ban_users,
                                probate_users,
                                create_experiments,
                                delete_own_experiments,
                                edit_own_experiments,
                                make_comments,
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
# Create backbones

Backbone.create!(:name => "pC.b.A",
                 :prefix => "GAATTCGCGGCCGCTTCTAGAGAAGACCATGGG",
                 :suffix => "GCCTAGGTCTTCACTAGTTGCGGCCGCTGCAG")
Backbone.create!(:name => "pC.b.B",
                 :prefix => "GAATTCGCGGCCGCTTCTAGAGAAGACCAGCCT",
                 :suffix => "TGGGTGGTCTTCACTAGTTGCGGCCGCTGCAG")
Backbone.create!(:name => "pC.f.A",
                 :prefix => "GAATTCGCGGCCGCTTCTAGACCTGCACCATGGG",
                 :suffix => "GCCTAGGTGCAGGTACTAGTTGCGGCCGCTGCAG")
Backbone.create!(:name => "pC.f.B",
                 :prefix => "GAATTCGCGGCCGCTTCTAGACCTGCACCAGCCT",
                 :suffix => "TGGGTGGTGCAGGTACTAGTTGCGGCCGCTGCAG")
Backbone.create!(:name => "pC.s.A",
                 :prefix => "GAATTCGCGGCCGCTTCTAGAGGTCTCATGGG",
                 :suffix => "GCCTAGAGACCACTAGTTGCGGCCGCTGCAG")
Backbone.create!(:name => "pC.s.B",
                 :prefix => "GAATTCGCGGCCGCTTCTAGAGGTCTCAGCCT",
                 :suffix => "TGGGTGAGACCACTAGTTGCGGCCGCTGCA")
                 

