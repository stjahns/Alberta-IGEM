class AddAbiFlagsToBiobytes < ActiveRecord::Migration
  def self.up
    add_column :bio_bytes, :vf_uploaded, :boolean
    add_column :bio_bytes, :vr_uploaded, :boolean
  end

  def self.down
    remove_column :bio_bytes, :vf_uploaded
    remove_column :bio_bytes, :vr_uploaded
  end
end
