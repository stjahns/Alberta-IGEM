# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# build permissions
require 'roles/permissions'

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
                 

