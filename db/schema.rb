# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140303061556) do

  create_table "stages_dogs", :primary_key => "id_stages_dog", :force => true do |t|
    t.integer  "id_work"
    t.string   "name_stage",      :limit => 145
    t.string   "name_work_stage", :limit => 245
    t.text     "comment"
    t.datetime "date_stop"
    t.datetime "date_start"
    t.integer  "stage_proc"
  end

  create_table "works_dogs", :primary_key => "id_work_dog", :force => true do |t|
    t.integer  "id_stages_dog"
    t.integer  "id_work"
    t.string   "index_work",    :limit => 45
    t.string   "name_work",     :limit => 245
    t.text     "comment"
    t.datetime "date_stop"
    t.datetime "date_start"
    t.integer  "procents"
    t.integer  "id_isp"
    t.integer  "status"
    t.datetime "date_done"
    t.text     "result"
  end

end
