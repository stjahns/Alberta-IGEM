# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101104050923) do

  create_table "annotations", :force => true do |t|
    t.string   "name"
    t.integer  "bio_byte_id"
    t.string   "description"
    t.string   "img_file_name"
    t.string   "colour"
    t.integer  "start"
    t.integer  "stop"
    t.integer  "strand"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backbones", :force => true do |t|
    t.string "name"
    t.string "prefix"
    t.string "suffix"
  end

  create_table "bio_byte_images", :force => true do |t|
    t.integer  "bio_byte_id"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bio_bytes", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "description"
    t.string   "author"
    t.string   "img_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_id"
    t.text     "val_string"
    t.text     "sequence"
    t.integer  "backbone_id"
    t.string   "biobrick_id"
    t.string   "biobrick_backbone"
    t.string   "biobyte_id"
    t.string   "biobyte_plasmid"
    t.text     "function_verification"
    t.text     "comments"
    t.boolean  "vf_uploaded"
    t.boolean  "vr_uploaded"
    t.integer  "category_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constructs", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "experiment_id"
  end

  create_table "encyclopaedias", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "intro"
    t.integer  "num_sections"
  end

  create_table "experiments", :force => true do |t|
    t.string   "title"
    t.string   "authour"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "status"
    t.boolean  "temp",        :default => false
    t.string   "articles"
  end

  create_table "glossaries", :force => true do |t|
    t.string   "term"
    t.text     "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_roles", :force => true do |t|
    t.integer  "group_id"
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "image_files", :force => true do |t|
    t.string   "image_filename"
    t.integer  "image_width"
    t.integer  "image_height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "image_filename"
    t.integer  "image_width"
    t.integer  "image_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "step_id"
    t.integer  "note_id"
    t.integer  "section_id"
    t.text     "caption"
    t.integer  "encyclopaedia_id"
  end

  create_table "messages", :force => true do |t|
    t.integer  "group_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "new_user_emails", :force => true do |t|
    t.string   "email"
    t.string   "key"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "step_id"
    t.string   "text"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", :force => true do |t|
    t.integer  "construct_id"
    t.integer  "bio_byte_id"
    t.integer  "part_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  create_table "requests", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "encyclopaedia_id"
    t.integer  "section_order"
    t.text     "video"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "video_title"
    t.text     "caption"
  end

  create_table "step_generators", :force => true do |t|
    t.string   "subprotocol"
    t.integer  "sub_order"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", :force => true do |t|
    t.text     "description"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "experiment_id"
    t.integer  "step_order"
    t.boolean  "autogenerated"
    t.boolean  "completed",     :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "role_id"
    t.string   "reset_code"
    t.text     "description"
    t.integer  "complete_counter"
    t.integer  "working_counter"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
