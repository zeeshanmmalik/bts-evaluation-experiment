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

ActiveRecord::Schema.define(:version => 20120330193017) do

  create_table "admins", :force => true do |t|
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

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "bug_reports", :force => true do |t|
    t.string   "title"
    t.string   "project"
    t.string   "original_link"
    t.integer  "experiment_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "bug_identifier"
  end

  add_index "bug_reports", ["experiment_id"], :name => "index_bug_reports_on_experiment_id"

  create_table "comments", :force => true do |t|
    t.datetime "submitted_at"
    t.integer  "number"
    t.integer  "participant_id"
    t.integer  "bug_report_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "comments", ["bug_report_id"], :name => "index_comments_on_bug_report_id"
  add_index "comments", ["participant_id"], :name => "index_comments_on_participant_id"

  create_table "emails", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.string   "email_type"
    t.integer  "experiment_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "emails", ["experiment_id"], :name => "index_emails_on_experiment_id"

  create_table "experiments", :force => true do |t|
    t.string   "title"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "participants", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "access_token"
    t.boolean  "is_selected"
    t.boolean  "is_email_sent"
    t.datetime "eval_started_at"
    t.datetime "eval_submitted_at"
    t.boolean  "is_reminder_sent"
    t.datetime "reminder_sent_at"
    t.integer  "reminder_count"
    t.integer  "experiment_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "bug_report_id"
    t.string   "username"
    t.string   "summary_assigned"
  end

  add_index "participants", ["bug_report_id"], :name => "index_participants_on_bug_report_id"
  add_index "participants", ["experiment_id"], :name => "index_participants_on_experiment_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "responses", :force => true do |t|
    t.integer  "imp_points_incl_lex_sum"
    t.integer  "imp_points_incl_email_sum"
    t.integer  "redundancy_lex_sum"
    t.integer  "redundancy_email_sum"
    t.integer  "unnecessary_info_lex_sum"
    t.integer  "unnecessary_info_email_sum"
    t.integer  "coherence_lex_sum"
    t.integer  "coherence_email_sum"
    t.string   "summary_view_pref"
    t.text     "view_pref_reason"
    t.boolean  "is_summarizing_br_helpful"
    t.text     "summarizing_reason"
    t.text     "important_info_in_summary"
    t.string   "contact_for_results"
    t.integer  "participant_id"
    t.integer  "bug_report_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "sum_help_bug_similar"
    t.integer  "sum_help_bug_workaround"
    t.integer  "sum_help_bug_status"
  end

  add_index "responses", ["bug_report_id"], :name => "index_responses_on_bug_report_id"
  add_index "responses", ["participant_id"], :name => "index_responses_on_participant_id"

  create_table "sentence_evaluations", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "sentence_id"
    t.integer  "importance"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "sentence_evaluations", ["participant_id", "sentence_id"], :name => "index_sentence_evaluations_on_participant_id_and_sentence_id"
  add_index "sentence_evaluations", ["participant_id"], :name => "index_sentence_evaluations_on_participant_id"
  add_index "sentence_evaluations", ["sentence_id"], :name => "index_sentence_evaluations_on_sentence_id"

  create_table "sentences", :force => true do |t|
    t.integer  "number"
    t.boolean  "is_in_lex_summary"
    t.boolean  "is_in_email_summary"
    t.integer  "comment_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "text"
  end

  add_index "sentences", ["comment_id"], :name => "index_sentences_on_comment_id"

end
