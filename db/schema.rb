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

ActiveRecord::Schema.define(:version => 20130815063651) do

  create_table "archives", :primary_key => "id_work", :force => true do |t|
    t.integer "id_sub_work"
    t.string  "name_full",    :limit => 345
    t.string  "name_small",   :limit => 145
    t.integer "id_otdel"
    t.integer "id_zakazchik"
    t.integer "pr_final"
    t.text    "comment",      :limit => 2147483647
    t.date    "date_start"
    t.date    "date_stop"
    t.string  "shifr",        :limit => 145
    t.string  "number_dog",   :limit => 145
    t.integer "id_manager"
  end

  add_index "archives", ["id_work"], :name => "id_work_UNIQUE", :unique => true

  create_table "archiveskdpd", :force => true do |t|
    t.integer "sub_id"
    t.string  "name",    :limit => 145
    t.text    "comment"
  end

  add_index "archiveskdpd", ["id"], :name => "id_UNIQUE", :unique => true

  create_table "documents", :primary_key => "id_document", :force => true do |t|
    t.integer "id_work"
    t.string  "path_file",       :limit => 145
    t.text    "comment",         :limit => 2147483647
    t.integer "id_user"
    t.string  "date",            :limit => 45
    t.integer "security"
    t.string  "size",            :limit => 45
    t.integer "archive_id"
    t.integer "standart_id"
    t.integer "archiveskdpd_id"
  end

  add_index "documents", ["id_document"], :name => "id_document_UNIQUE", :unique => true

  create_table "managers", :primary_key => "id_manager", :force => true do |t|
    t.string "fio",        :limit => 180
    t.string "occupation", :limit => 180
  end

  add_index "managers", ["id_manager"], :name => "id_manager_UNIQUE", :unique => true

  create_table "otdel_dfct", :primary_key => "id_otdel", :force => true do |t|
    t.string "name_full",  :limit => 245
    t.string "name_small", :limit => 145
    t.string "comment",    :limit => 345
  end

  add_index "otdel_dfct", ["id_otdel"], :name => "id_otdel_UNIQUE", :unique => true

  create_table "standarts", :force => true do |t|
    t.integer "sub_id"
    t.string  "name",    :limit => 145
    t.text    "comment"
  end

  add_index "standarts", ["id"], :name => "id_UNIQUE", :unique => true

  create_table "users", :primary_key => "id_user", :force => true do |t|
    t.string  "fio",      :limit => 245
    t.string  "comment",  :limit => 345
    t.string  "login",    :limit => 45
    t.string  "password", :limit => 45
    t.integer "pr_admin"
  end

  add_index "users", ["id_user"], :name => "id_user_UNIQUE", :unique => true

  create_table "work_sub_works", :primary_key => "id_work", :force => true do |t|
    t.integer "id_sub_work"
    t.string  "name_full",    :limit => 345
    t.string  "name_small",   :limit => 145
    t.integer "id_otdel"
    t.integer "id_zakazchik"
    t.integer "pr_final"
    t.text    "comment",      :limit => 2147483647
    t.date    "date_start"
    t.date    "date_stop"
    t.string  "shifr",        :limit => 145
    t.string  "number_dog",   :limit => 145
    t.integer "id_manager"
  end

  add_index "work_sub_works", ["id_work"], :name => "id_work_UNIQUE", :unique => true

  create_table "zakazchik", :primary_key => "id_zakazchik", :force => true do |t|
    t.string "name_full",  :limit => 245
    t.string "name_small", :limit => 145
  end

  add_index "zakazchik", ["id_zakazchik"], :name => "id_zakazchik_UNIQUE", :unique => true

end
