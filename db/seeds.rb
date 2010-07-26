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
delete_users=Permission.create!(:name => 'delete_users',
                  :description => "Allowed to delete any user")
delete_constructs=Permission.create!(:name => 'delete_constructs',
                  :description => "Allowed to delete any construct")
delete_experiments=Permission.create!(:name => 'delete_experiments',
                  :description => "Allowed to delete any experiment")
delete_steps=Permission.create!(:name => 'delete_steps',
                  :description => "Allowed to delete any step")




#create roles
admin_role=Role.create!(:name => 'admin', 
                :description => "Primary administrator role",
                :permissions => [create_bio_bytes,
                                 delete_users,
                                 delete_experiments,
                                 delete_constructs,
                                 delete_steps])

#create an admin user
admin_user=User.create!(:login => 'admin', 
            :role_id => admin_role.id,
            :email => 'genomikon@gmail.com',
            :password => 'password',
            :password_confirmation => 'password')
admin_user.role = admin_role # can't mass assign
admin_user.save
#----- NB - still need to activate through the email
           

