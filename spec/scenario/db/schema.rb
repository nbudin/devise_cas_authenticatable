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

ActiveRecord::Schema.define(:version => 20140130231149) do

  create_table "casserver_lt", :force => true do |t|
    t.string   "ticket",          :null => false
    t.datetime "created_on",      :null => false
    t.datetime "consumed"
    t.string   "client_hostname", :null => false
  end

  create_table "casserver_pgt", :force => true do |t|
    t.string   "ticket",            :null => false
    t.datetime "created_on",        :null => false
    t.string   "client_hostname",   :null => false
    t.string   "iou",               :null => false
    t.integer  "service_ticket_id", :null => false
  end

  create_table "casserver_st", :force => true do |t|
    t.string   "ticket",            :null => false
    t.text     "service",           :null => false
    t.datetime "created_on",        :null => false
    t.datetime "consumed"
    t.string   "client_hostname",   :null => false
    t.string   "username",          :null => false
    t.string   "type",              :null => false
    t.integer  "granted_by_pgt_id"
    t.integer  "granted_by_tgt_id"
  end

  create_table "casserver_tgt", :force => true do |t|
    t.string   "ticket",           :null => false
    t.datetime "created_on",       :null => false
    t.string   "client_hostname",  :null => false
    t.string   "username",         :null => false
    t.text     "extra_attributes"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "username",            :null => false
    t.datetime "remember_created_at"
    t.string   "email"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "deactivated"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
