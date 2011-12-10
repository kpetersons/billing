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

ActiveRecord::Schema.define(:version => 20111210151805) do

  create_table "accounts", :force => true do |t|
    t.string   "bank"
    t.string   "bank_code"
    t.string   "account_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "default_account"
    t.boolean  "show_on_invoice"
  end

  create_table "address_types", :force => true do |t|
    t.string   "name"
    t.boolean  "built_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "party_id"
  end

  create_table "addresses", :force => true do |t|
    t.integer  "party_id"
    t.integer  "address_type_id"
    t.string   "city"
    t.string   "street"
    t.string   "house_number"
    t.string   "room_number"
    t.string   "post_code"
    t.string   "po_box"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.integer  "version",            :default => 1
    t.integer  "orig_id"
    t.date     "date_effective",     :default => '2011-12-03'
    t.datetime "date_effective_end"
  end

  create_table "attorney_fee_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operating_party_id"
    t.boolean  "apply_vat"
    t.boolean  "apply_discount"
  end

  create_table "clazzs", :force => true do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.integer  "party_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "registration_number"
    t.integer  "version",             :default => 1
    t.integer  "orig_id"
    t.date     "date_effective",      :default => '2011-12-03'
    t.datetime "date_effective_end"
  end

  create_table "contact_types", :force => true do |t|
    t.string   "name"
    t.boolean  "built_in"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "party_id"
    t.integer  "contact_type_id"
    t.string   "contact_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.integer  "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_type"
    t.string   "vat_registration_number"
    t.integer  "version",                 :default => 1
    t.integer  "orig_id"
    t.date     "date_effective",          :default => '2011-12-03'
    t.datetime "date_effective_end"
    t.text     "shortnote"
  end

  create_table "customs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matter_id"
    t.date     "date_of_order_alert"
    t.date     "ca_application_date"
    t.string   "ca_application_number"
    t.integer  "client_all_ip_id"
    t.text     "vid_ref"
  end

  create_table "default_filter_columns", :force => true do |t|
    t.string   "column_name"
    t.string   "column_type"
    t.string   "column_query"
    t.integer  "column_position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_filter_id"
    t.boolean  "is_default"
    t.string   "column_order_query"
    t.boolean  "translate",          :default => false
  end

  create_table "default_filters", :force => true do |t|
    t.string   "table_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "designs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matter_id"
    t.string   "application_number"
    t.date     "application_date"
    t.string   "design_number"
    t.string   "rdc_appl_number"
    t.string   "rdc_number"
    t.date     "registration_date"
  end

  create_table "document_tags", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
    t.integer  "tag_id"
  end

  create_table "documents", :force => true do |t|
    t.integer  "user_id"
    t.string   "registration_number"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "notes"
    t.integer  "version",             :default => 1
    t.integer  "orig_id"
    t.date     "date_effective",      :default => '2011-12-03'
    t.datetime "date_effective_end"
  end

  create_table "domains", :force => true do |t|
    t.integer  "matter_id"
    t.string   "domain_name"
    t.date     "registration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchange_rates", :force => true do |t|
    t.integer  "currency_id"
    t.decimal  "rate",         :precision => 8, :scale => 3
    t.date     "from_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "through_date"
  end

  create_table "functions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "individuals", :force => true do |t|
    t.integer  "party_id"
    t.integer  "gender_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_line_presets", :force => true do |t|
    t.integer  "operating_party_id"
    t.integer  "official_fee_type_id"
    t.integer  "attorney_fee_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.boolean  "private_preset"
    t.decimal  "official_fee",         :precision => 8, :scale => 2
    t.decimal  "attorney_fee",         :precision => 8, :scale => 2
    t.integer  "currency_id"
    t.integer  "orig_id"
    t.date     "date_effective"
    t.date     "date_effective_end"
  end

  create_table "invoice_lines", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "official_fee_type_id"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attorney_fee_type_id"
    t.decimal  "official_fee",         :precision => 8,  :scale => 2
    t.decimal  "attorney_fee",         :precision => 8,  :scale => 2
    t.integer  "author_id"
    t.string   "offering"
    t.decimal  "items",                :precision => 10, :scale => 2
    t.string   "units"
    t.decimal  "total",                :precision => 10, :scale => 2
    t.decimal  "total_attorney_fee",   :precision => 10, :scale => 2
    t.decimal  "total_official_fee",   :precision => 10, :scale => 2
    t.decimal  "total_discount",       :precision => 10, :scale => 2
  end

  create_table "invoice_matters", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "matter_id"
    t.integer  "matter_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_status_flows", :force => true do |t|
    t.integer  "revert_to_step_id"
    t.integer  "current_step_id"
    t.integer  "pass_to_step_id"
    t.integer  "pass_to_function_id"
    t.integer  "revert_to_function_id"
    t.boolean  "start_state",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "function_id"
    t.boolean  "editable_state"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "document_id"
    t.integer  "customer_id"
    t.integer  "address_id"
    t.integer  "individual_id"
    t.integer  "currency_id"
    t.integer  "exchange_rate_id"
    t.integer  "discount"
    t.string   "our_ref"
    t.string   "your_ref"
    t.date     "your_date"
    t.string   "po_billing"
    t.string   "finishing_details"
    t.date     "invoice_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.decimal  "exchange_rate",                     :precision => 7, :scale => 4
    t.string   "subject",           :limit => 2000
    t.string   "ending_details",    :limit => 2000
    t.integer  "payment_term",      :limit => 2
    t.boolean  "apply_vat"
    t.integer  "invoice_status_id"
    t.date     "date_paid"
    t.integer  "foreign_number"
    t.integer  "local_number"
    t.integer  "invoice_type"
  end

  create_table "legal_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "description"
  end

  create_table "legals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matter_id"
    t.string   "opposed_marks"
    t.string   "instance"
    t.date     "date_of_closure"
    t.integer  "opposite_party_id"
    t.integer  "opposite_party_agent_id"
    t.integer  "legal_type_id"
    t.date     "date_of_order"
    t.text     "court_ref"
  end

  create_table "linked_matters", :force => true do |t|
    t.integer  "matter_id"
    t.integer  "linked_matter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matter_clazzs", :force => true do |t|
    t.integer  "matter_id"
    t.integer  "clazz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matter_customers", :force => true do |t|
    t.integer  "matter_id"
    t.integer  "customer_id"
    t.date     "takeover_date"
    t.string   "shortnote"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.string   "customer_type"
  end

  create_table "matter_images", :force => true do |t|
    t.integer  "matter_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matter_status_flows", :force => true do |t|
    t.integer  "revert_to_step_id"
    t.integer  "current_step_id"
    t.integer  "pass_to_step_id"
    t.integer  "pass_to_function_id"
    t.integer  "revert_to_function_id"
    t.boolean  "start_state",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matter_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "function_id"
  end

  create_table "matter_task_status_flows", :force => true do |t|
    t.integer  "revert_to_step_id"
    t.integer  "current_step_id"
    t.integer  "pass_to_step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "start_state",           :default => false
    t.integer  "pass_to_function_id"
    t.integer  "revert_to_function_id"
  end

  create_table "matter_task_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "function_id"
  end

  create_table "matter_task_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matter_tasks", :force => true do |t|
    t.integer  "matter_id"
    t.integer  "matter_task_status_id"
    t.string   "description"
    t.date     "proposed_deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.integer  "matter_task_type_id"
  end

  create_table "matter_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "function_id"
  end

  create_table "matters", :force => true do |t|
    t.integer  "document_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "applicant_id"
    t.date     "priority_date"
    t.string   "ctm_number"
    t.string   "wipo_number"
    t.string   "ir_number"
    t.string   "mark_name"
    t.date     "appl_date"
    t.string   "appl_number"
    t.integer  "agent_id"
    t.integer  "author_id"
    t.integer  "matter_type_id"
    t.integer  "operating_party_id"
    t.integer  "matter_status_id"
    t.integer  "version",            :default => 1
    t.integer  "orig_id"
    t.date     "date_effective",     :default => '2011-12-03'
    t.datetime "date_effective_end"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "official_fee_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operating_party_id"
    t.boolean  "apply_vat"
    t.boolean  "apply_discount"
  end

  create_table "operating_parties", :force => true do |t|
    t.integer  "company_id"
    t.integer  "operating_party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operating_party_matter_types", :force => true do |t|
    t.integer  "operating_party_id"
    t.integer  "matter_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operating_party_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "operating_party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", :force => true do |t|
    t.string   "identifier"
    t.string   "party_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",            :default => 1
    t.integer  "orig_id"
    t.date     "date_effective",     :default => '2011-12-03'
    t.datetime "date_effective_end"
  end

  create_table "patent_searches", :force => true do |t|
    t.integer  "matter_id"
    t.string   "description"
    t.string   "patent_eq_numbers"
    t.integer  "no_of_patents",     :limit => 2
    t.date     "date_of_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patents", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matter_id"
    t.string   "application_number"
    t.date     "application_date"
    t.string   "patent_number"
    t.date     "patent_grant_date"
    t.string   "ep_appl_number"
    t.integer  "ep_number"
    t.date     "registration_date"
  end

  create_table "relationship_types", :force => true do |t|
    t.string   "name"
    t.boolean  "built_in"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "source_party_id"
    t.integer  "target_party_id"
    t.integer  "relationship_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_functions", :force => true do |t|
    t.integer  "role_id"
    t.integer  "function_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "matter_id"
    t.string   "search_for"
    t.integer  "no_of_objects",  :limit => 2
    t.boolean  "express_search"
    t.date     "date_of_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trademarks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matter_id"
    t.date     "appl_date"
    t.string   "appl_number"
    t.string   "notes"
    t.string   "mark_name"
    t.string   "cfe_index"
    t.date     "application_date"
    t.string   "application_number"
    t.date     "priority_date"
    t.string   "ctm_number"
    t.string   "wipo_number"
    t.string   "reg_number"
    t.date     "registration_date"
  end

  create_table "user_filter_columns", :force => true do |t|
    t.integer  "user_filter_id"
    t.string   "column_name"
    t.string   "column_type"
    t.string   "column_query"
    t.integer  "column_position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "column_order_query"
    t.boolean  "translate",          :default => false
  end

  create_table "user_filters", :force => true do |t|
    t.integer  "user_id"
    t.string   "table_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "individual_id"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "active"
    t.boolean  "blocked"
    t.date     "registration_date"
    t.string   "activation_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operating_party_id"
    t.string   "initials"
    t.datetime "login_date"
    t.datetime "last_login_date"
  end

end
