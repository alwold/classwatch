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

ActiveRecord::Schema.define(:version => 20120417035021) do

  create_table "course", :primary_key => "course_id", :force => true do |t|
    t.string  "course_number", :limit => 15, :null => false
    t.integer "term_id"
  end

  add_index "course", ["term_id", "course_number"], :name => "index_course_on_term_id_and_course_number", :unique => true

  create_table "course_status", :force => true do |t|
    t.datetime "status_timestamp"
    t.string   "status"
    t.integer  "course_id"
  end

  create_table "notification", :primary_key => "notification_id", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "notification_timestamp"
    t.string   "type",                   :limit => 50
    t.string   "status",                 :limit => 10, :null => false
    t.integer  "attempts",                             :null => false
    t.string   "info"
    t.datetime "last_attempt"
  end

  create_table "notifier_setting", :primary_key => "notifier_setting_id", :force => true do |t|
    t.string  "type",           :limit => 50
    t.boolean "enabled",                      :null => false
    t.integer "user_course_id"
  end

  create_table "school", :primary_key => "school_id", :force => true do |t|
    t.string "name",         :null => false
    t.string "scraper_type", :null => false
  end

  create_table "term", :primary_key => "term_id", :force => true do |t|
    t.string  "term_code",  :limit => 10
    t.string  "name",       :limit => 100, :null => false
    t.date    "start_date",                :null => false
    t.date    "end_date",                  :null => false
    t.integer "school_id"
  end

  create_table "user_course", :force => true do |t|
    t.boolean "notified",  :null => false
    t.boolean "paid",      :null => false
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "user_course", ["user_id", "course_id"], :name => "index_user_course_on_user_id_and_course_id", :unique => true

  create_table "users", :primary_key => "user_id", :force => true do |t|
    t.string   "phone",                  :limit => 25
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
