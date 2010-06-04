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

ActiveRecord::Schema.define(:version => 20100603151147) do

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

  create_table "bio_bytes", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "description"
    t.string   "sequence"
    t.string   "author"
    t.string   "img_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constructs", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "author"
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

end
