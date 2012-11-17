class RemoveReputaionsTables < ActiveRecord::Migration
  def up
    drop_table :rs_evaluations
    drop_table :rs_reputation_messages
    drop_table :rs_reputations
  end

  def down
    create_table "rs_evaluations", :force => true do |t|
      t.string   "reputation_name"
      t.integer  "source_id"
      t.string   "source_type"
      t.integer  "target_id"
      t.string   "target_type"
      t.float    "value",           :default => 0.0
      t.datetime "created_at",                       :null => false
      t.datetime "updated_at",                       :null => false
    end

    add_index "rs_evaluations", ["reputation_name", "source_id", "source_type", "target_id", "target_type"], :name => "index_rs_evaluations_on_reputation_name_and_source_and_target", :unique => true
    add_index "rs_evaluations", ["reputation_name"], :name => "index_rs_evaluations_on_reputation_name"
    add_index "rs_evaluations", ["source_id", "source_type"], :name => "index_rs_evaluations_on_source_id_and_source_type"
    add_index "rs_evaluations", ["target_id", "target_type"], :name => "index_rs_evaluations_on_target_id_and_target_type"

    create_table "rs_reputation_messages", :force => true do |t|
      t.integer  "sender_id"
      t.string   "sender_type"
      t.integer  "receiver_id"
      t.float    "weight",      :default => 1.0
      t.datetime "created_at",                   :null => false
      t.datetime "updated_at",                   :null => false
    end

    add_index "rs_reputation_messages", ["receiver_id", "sender_id", "sender_type"], :name => "index_rs_reputation_messages_on_receiver_id_and_sender", :unique => true
    add_index "rs_reputation_messages", ["receiver_id"], :name => "index_rs_reputation_messages_on_receiver_id"
    add_index "rs_reputation_messages", ["sender_id", "sender_type"], :name => "index_rs_reputation_messages_on_sender_id_and_sender_type"

    create_table "rs_reputations", :force => true do |t|
      t.string   "reputation_name"
      t.float    "value",           :default => 0.0
      t.string   "aggregated_by"
      t.integer  "target_id"
      t.string   "target_type"
      t.boolean  "active",          :default => true
      t.datetime "created_at",                        :null => false
      t.datetime "updated_at",                        :null => false
    end

    add_index "rs_reputations", ["reputation_name", "target_id", "target_type"], :name => "index_rs_reputations_on_reputation_name_and_target", :unique => true
    add_index "rs_reputations", ["reputation_name"], :name => "index_rs_reputations_on_reputation_name"
    add_index "rs_reputations", ["target_id", "target_type"], :name => "index_rs_reputations_on_target_id_and_target_type"
  end
end
