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

ActiveRecord::Schema.define(:version => 20140420125728) do

  create_table "users", :force => true do |t|
    t.string   "mail"
    t.string   "question"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.boolean  "frozen_now",                        :default => false
    t.string   "password"
    t.string   "comment",           :limit => 1500
    t.boolean  "is_phone_assigned",                 :default => false
    t.integer  "response_status"
  end

  add_index "users", ["is_phone_assigned"], :name => "index_users_on_is_phone_assigned"
  add_index "users", ["response_status"], :name => "index_users_on_response_status"

end
