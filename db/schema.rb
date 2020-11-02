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

ActiveRecord::Schema.define(:version => 0) do

  create_table "docs", :force => true do |t|
    t.string   "title",                             :default => "", :null => false
    t.text     "legend",                                            :null => false
    t.string   "location",                          :default => "", :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size",    :limit => 11
    t.datetime "avatar_updated_at"
  end

  create_table "experiments", :force => true do |t|
    t.text "goal",       :null => false
    t.text "protocole",  :null => false
    t.text "result",     :null => false
    t.text "conclusion", :null => false
    t.text "summary",    :null => false
  end

  create_table "linkexpdocs", :force => true do |t|
    t.integer "doc_id",        :limit => 11, :null => false
    t.integer "experiment_id", :limit => 11, :null => false
  end

  add_index "linkexpdocs", ["doc_id"], :name => "fk_linkexpdoc_doc"
  add_index "linkexpdocs", ["experiment_id"], :name => "fk_linkexpdoc_experiment"

end
