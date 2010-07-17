class CreateAdminRole < ActiveRecord::Migration
  def self.up
	  Role.create(:name=>'admin')
  end

  def self.down
	  Role.find_by_name('admin').destroy
  end
end
