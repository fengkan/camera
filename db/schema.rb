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

ActiveRecord::Schema.define(:version => 20140214094622) do

  create_table "jobs", :force => true do |t|
    t.string   "name",       :limit => 100
    t.string   "status",     :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_histories", :force => true do |t|
    t.integer  "order_id",                 :null => false
    t.string   "status",     :limit => 20, :null => false
    t.datetime "created_at",               :null => false
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id",                 :null => false
    t.integer  "job_id",                   :null => false
    t.string   "job_style",  :limit => 20
    t.integer  "job_amount"
    t.float    "price"
    t.datetime "created_at",               :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.integer  "shipment_id",                :null => false
    t.string   "status",      :limit => 20
    t.string   "logistics",   :limit => 200
    t.datetime "created_at",                 :null => false
    t.string   "md5",         :limit => 40,  :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "job_id"
    t.string   "filename",   :limit => 100
    t.datetime "created_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shipments", :force => true do |t|
    t.integer  "user_id",                                :null => false
    t.text     "name"
    t.text     "address"
    t.text     "phone"
    t.text     "postcode"
    t.integer  "del_flg",    :limit => 1, :default => 0, :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
