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

ActiveRecord::Schema.define(:version => 20130223125554) do

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

  add_index "accounts", ["company_id"], :name => "index_accounts_on_company_id"

  create_table "address_types", :force => true do |t|
    t.string   "name"
    t.boolean  "built_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "party_id"
  end

  add_index "address_types", ["party_id"], :name => "index_address_types_on_party_id"

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
    t.date     "date_effective",     :default => '2012-12-25'
    t.datetime "date_effective_end"
    t.boolean  "suspended"
  end

  add_index "addresses", ["address_type_id"], :name => "index_addresses_on_address_type_id"
  add_index "addresses", ["country_id"], :name => "index_addresses_on_country_id"
  add_index "addresses", ["orig_id"], :name => "index_addresses_on_orig_id"
  add_index "addresses", ["party_id"], :name => "index_addresses_on_party_id"

  create_table "attorney_fee_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operating_party_id"
    t.boolean  "apply_vat"
    t.boolean  "apply_discount"
  end

  add_index "attorney_fee_types", ["operating_party_id"], :name => "index_attorney_fee_types_on_operating_party_id"

  create_table "billing_settings", :force => true do |t|
    t.decimal  "vat_rate",         :precision => 8, :scale => 2
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "activated_when"
    t.date     "deactivated_when"
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
    t.date     "date_effective",      :default => '2012-12-25'
    t.datetime "date_effective_end"
  end

  add_index "companies", ["orig_id"], :name => "index_companies_on_orig_id"
  add_index "companies", ["party_id"], :name => "index_companies_on_party_id"

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

  add_index "contacts", ["contact_type_id"], :name => "index_contacts_on_contact_type_id"
  add_index "contacts", ["party_id"], :name => "index_contacts_on_party_id"

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
    t.date     "date_effective",          :default => '2012-12-25'
    t.datetime "date_effective_end"
    t.text     "shortnote"
  end

  add_index "customers", ["party_id"], :name => "index_customers_on_party_id"

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

  add_index "customs", ["client_all_ip_id"], :name => "index_customs_on_client_all_ip_id"
  add_index "customs", ["matter_id"], :name => "index_customs_on_matter_id"

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

  add_index "default_filter_columns", ["column_name"], :name => "index_default_filter_columns_on_column_name"
  add_index "default_filter_columns", ["column_position"], :name => "index_default_filter_columns_on_column_position"
  add_index "default_filter_columns", ["column_query"], :name => "index_default_filter_columns_on_column_query"
  add_index "default_filter_columns", ["column_type"], :name => "index_default_filter_columns_on_column_type"
  add_index "default_filter_columns", ["default_filter_id"], :name => "index_default_filter_columns_on_default_filter_id"

  create_table "default_filters", :force => true do |t|
    t.string   "table_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "default_filters", ["table_name"], :name => "index_default_filters_on_table_name", :unique => true

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

  add_index "designs", ["matter_id"], :name => "index_designs_on_matter_id"

  create_table "document_tags", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
    t.integer  "tag_id"
  end

  add_index "document_tags", ["document_id"], :name => "index_document_tags_on_document_id"
  add_index "document_tags", ["tag_id"], :name => "index_document_tags_on_tag_id"

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
    t.date     "date_effective",      :default => '2012-12-25'
    t.datetime "date_effective_end"
  end

  add_index "documents", ["parent_id"], :name => "index_documents_on_parent_id"
  add_index "documents", ["registration_number"], :name => "index_documents_on_registration_number"
  add_index "documents", ["updated_at"], :name => "index_documents_on_updated_at"
  add_index "documents", ["user_id"], :name => "index_documents_on_user_id"

  create_table "domains", :force => true do |t|
    t.integer  "matter_id"
    t.string   "domain_name"
    t.date     "registration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domains", ["matter_id"], :name => "index_domains_on_matter_id"

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

  add_index "functions", ["name"], :name => "index_functions_on_name", :unique => true

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

  add_index "individuals", ["gender_id"], :name => "index_individuals_on_gender_id"
  add_index "individuals", ["party_id"], :name => "index_individuals_on_party_id"

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

  add_index "invoice_line_presets", ["attorney_fee_type_id"], :name => "index_invoice_line_presets_on_attorney_fee_type_id"
  add_index "invoice_line_presets", ["author_id"], :name => "index_invoice_line_presets_on_author_id"
  add_index "invoice_line_presets", ["currency_id"], :name => "index_invoice_line_presets_on_currency_id"
  add_index "invoice_line_presets", ["official_fee_type_id"], :name => "index_invoice_line_presets_on_official_fee_type_id"
  add_index "invoice_line_presets", ["operating_party_id"], :name => "index_invoice_line_presets_on_operating_party_id"
  add_index "invoice_line_presets", ["orig_id"], :name => "index_invoice_line_presets_on_orig_id"

  create_table "invoice_lines", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "official_fee_type_id"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attorney_fee_type_id"
    t.text     "offering"
    t.decimal  "official_fee",         :precision => 8,  :scale => 2
    t.decimal  "attorney_fee",         :precision => 8,  :scale => 2
    t.integer  "author_id"
    t.decimal  "items",                :precision => 10, :scale => 2
    t.string   "units"
    t.decimal  "total",                :precision => 10, :scale => 2
    t.decimal  "total_attorney_fee",   :precision => 10, :scale => 2
    t.decimal  "total_official_fee",   :precision => 10, :scale => 2
    t.decimal  "total_discount",       :precision => 10, :scale => 2
    t.integer  "billing_settings_id"
  end

  add_index "invoice_lines", ["attorney_fee_type_id"], :name => "index_invoice_lines_on_attorney_fee_type_id"
  add_index "invoice_lines", ["invoice_id"], :name => "index_invoice_lines_on_invoice_id"
  add_index "invoice_lines", ["official_fee_type_id"], :name => "index_invoice_lines_on_official_fee_type_id"

  create_table "invoice_matters", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "matter_id"
    t.integer  "matter_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_matters", ["invoice_id"], :name => "index_invoice_matters_on_invoice_id"
  add_index "invoice_matters", ["matter_id"], :name => "index_invoice_matters_on_matter_id"
  add_index "invoice_matters", ["matter_task_id"], :name => "index_invoice_matters_on_matter_task_id"

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

  add_index "invoice_status_flows", ["current_step_id"], :name => "index_invoice_status_flows_on_current_step_id"
  add_index "invoice_status_flows", ["pass_to_function_id"], :name => "index_invoice_status_flows_on_pass_to_function_id"
  add_index "invoice_status_flows", ["pass_to_step_id"], :name => "index_invoice_status_flows_on_pass_to_step_id"
  add_index "invoice_status_flows", ["revert_to_function_id"], :name => "index_invoice_status_flows_on_revert_to_function_id"
  add_index "invoice_status_flows", ["revert_to_step_id"], :name => "index_invoice_status_flows_on_revert_to_step_id"

  create_table "invoice_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "function_id"
    t.boolean  "editable_state"
  end

  add_index "invoice_statuses", ["function_id"], :name => "index_invoice_statuses_on_function_id"

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
    t.decimal  "exchange_rate",                       :precision => 7, :scale => 4
    t.string   "subject",             :limit => 2000
    t.string   "ending_details",      :limit => 2000
    t.integer  "payment_term",        :limit => 2
    t.boolean  "apply_vat"
    t.integer  "invoice_status_id"
    t.date     "date_paid"
    t.integer  "foreign_number"
    t.integer  "local_number"
    t.integer  "invoice_type"
    t.integer  "matter_type_id"
    t.string   "author_name"
    t.integer  "billing_settings_id"
  end

  add_index "invoices", ["address_id"], :name => "index_invoices_on_address_id"
  add_index "invoices", ["currency_id"], :name => "index_invoices_on_currency_id"
  add_index "invoices", ["customer_id"], :name => "index_invoices_on_customer_id"
  add_index "invoices", ["document_id"], :name => "index_invoices_on_document_id"
  add_index "invoices", ["exchange_rate_id"], :name => "index_invoices_on_exchange_rate_id"
  add_index "invoices", ["individual_id"], :name => "index_invoices_on_individual_id"
  add_index "invoices", ["invoice_status_id"], :name => "index_invoices_on_invoice_status_id"
  add_index "invoices", ["matter_type_id"], :name => "index_invoices_on_matter_type_id"

  create_table "legal_types", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
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
    t.string   "mark_name"
  end

  add_index "legals", ["legal_type_id"], :name => "index_legals_on_legal_type_id"
  add_index "legals", ["matter_id"], :name => "index_legals_on_matter_id"
  add_index "legals", ["opposite_party_agent_id"], :name => "index_legals_on_opposite_party_agent_id"
  add_index "legals", ["opposite_party_id"], :name => "index_legals_on_opposite_party_id"

  create_table "linked_matters", :force => true do |t|
    t.integer  "matter_id"
    t.integer  "linked_matter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "linked_matters", ["linked_matter_id"], :name => "index_linked_matters_on_linked_matter_id"
  add_index "linked_matters", ["matter_id"], :name => "index_linked_matters_on_matter_id"

  create_table "matter_clazzs", :force => true do |t|
    t.integer  "matter_id"
    t.integer  "clazz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matter_clazzs", ["clazz_id"], :name => "index_matter_clazzs_on_clazz_id"
  add_index "matter_clazzs", ["matter_id"], :name => "index_matter_clazzs_on_matter_id"

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

  add_index "matter_customers", ["author_id"], :name => "index_matter_customers_on_author_id"
  add_index "matter_customers", ["customer_id"], :name => "index_matter_customers_on_customer_id"
  add_index "matter_customers", ["matter_id"], :name => "index_matter_customers_on_matter_id"

  create_table "matter_images", :force => true do |t|
    t.integer  "matter_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matter_images", ["matter_id"], :name => "index_matter_images_on_matter_id"

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

  add_index "matter_status_flows", ["current_step_id"], :name => "index_matter_status_flows_on_current_step_id"
  add_index "matter_status_flows", ["pass_to_function_id"], :name => "index_matter_status_flows_on_pass_to_function_id"
  add_index "matter_status_flows", ["pass_to_step_id"], :name => "index_matter_status_flows_on_pass_to_step_id"
  add_index "matter_status_flows", ["revert_to_function_id"], :name => "index_matter_status_flows_on_revert_to_function_id"
  add_index "matter_status_flows", ["revert_to_step_id"], :name => "index_matter_status_flows_on_revert_to_step_id"

  create_table "matter_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "function_id"
  end

  add_index "matter_statuses", ["function_id"], :name => "index_matter_statuses_on_function_id"

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

  add_index "matter_task_status_flows", ["current_step_id"], :name => "index_matter_task_status_flows_on_current_step_id"
  add_index "matter_task_status_flows", ["pass_to_function_id"], :name => "index_matter_task_status_flows_on_pass_to_function_id"
  add_index "matter_task_status_flows", ["pass_to_step_id"], :name => "index_matter_task_status_flows_on_pass_to_step_id"
  add_index "matter_task_status_flows", ["revert_to_function_id"], :name => "index_matter_task_status_flows_on_revert_to_function_id"
  add_index "matter_task_status_flows", ["revert_to_step_id"], :name => "index_matter_task_status_flows_on_revert_to_step_id"

  create_table "matter_task_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "function_id"
  end

  add_index "matter_task_statuses", ["function_id"], :name => "index_matter_task_statuses_on_function_id"
  add_index "matter_task_statuses", ["name"], :name => "index_matter_task_statuses_on_name"

  create_table "matter_task_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matter_task_types", ["name"], :name => "index_matter_task_types_on_name"

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

  add_index "matter_tasks", ["author_id"], :name => "index_matter_tasks_on_author_id"
  add_index "matter_tasks", ["matter_id"], :name => "index_matter_tasks_on_matter_id"
  add_index "matter_tasks", ["matter_task_status_id"], :name => "index_matter_tasks_on_matter_task_status_id"
  add_index "matter_tasks", ["matter_task_type_id"], :name => "index_matter_tasks_on_matter_task_type_id"

  create_table "matter_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "function_id"
  end

  add_index "matter_types", ["function_id"], :name => "index_matter_types_on_function_id"

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
    t.date     "date_effective",     :default => '2012-12-25'
    t.datetime "date_effective_end"
  end

  add_index "matters", ["agent_id"], :name => "index_matters_on_agent_id"
  add_index "matters", ["applicant_id"], :name => "index_matters_on_applicant_id"
  add_index "matters", ["author_id"], :name => "index_matters_on_author_id"
  add_index "matters", ["document_id"], :name => "index_matters_on_document_id"
  add_index "matters", ["matter_status_id"], :name => "index_matters_on_matter_status_id"
  add_index "matters", ["matter_type_id"], :name => "index_matters_on_matter_type_id"
  add_index "matters", ["operating_party_id"], :name => "index_matters_on_operating_party_id"
  add_index "matters", ["orig_id", "version"], :name => "index_matters_on_orig_id_and_version"
  add_index "matters", ["orig_id"], :name => "index_matters_on_orig_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "official_fee_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operating_party_id"
    t.boolean  "apply_vat"
    t.boolean  "apply_discount"
  end

  add_index "official_fee_types", ["operating_party_id"], :name => "index_official_fee_types_on_operating_party_id"

  create_table "operating_parties", :force => true do |t|
    t.integer  "company_id"
    t.integer  "operating_party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operating_parties", ["company_id"], :name => "index_operating_parties_on_company_id"
  add_index "operating_parties", ["operating_party_id"], :name => "index_operating_parties_on_operating_party_id"

  create_table "operating_party_matter_types", :force => true do |t|
    t.integer  "operating_party_id"
    t.integer  "matter_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operating_party_matter_types", ["matter_type_id"], :name => "index_operating_party_matter_types_on_matter_type_id"
  add_index "operating_party_matter_types", ["operating_party_id"], :name => "index_operating_party_matter_types_on_operating_party_id"

  create_table "operating_party_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "operating_party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operating_party_users", ["operating_party_id"], :name => "index_operating_party_users_on_operating_party_id"
  add_index "operating_party_users", ["user_id"], :name => "index_operating_party_users_on_user_id"

  create_table "parties", :force => true do |t|
    t.string   "identifier"
    t.string   "party_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",            :default => 1
    t.integer  "orig_id"
    t.date     "date_effective",     :default => '2012-12-25'
    t.datetime "date_effective_end"
  end

  add_index "parties", ["orig_id"], :name => "index_parties_on_orig_id"

  create_table "patent_searches", :force => true do |t|
    t.integer  "matter_id"
    t.string   "description"
    t.string   "patent_eq_numbers"
    t.integer  "no_of_patents",     :limit => 2
    t.date     "date_of_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patent_searches", ["matter_id"], :name => "index_patent_searches_on_matter_id"

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

  add_index "patents", ["matter_id"], :name => "index_patents_on_matter_id"

  create_table "relationship_types", :force => true do |t|
    t.string   "name"
    t.boolean  "built_in"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationship_types", ["name"], :name => "index_relationship_types_on_name"

  create_table "relationships", :force => true do |t|
    t.integer  "source_party_id"
    t.integer  "target_party_id"
    t.integer  "relationship_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["relationship_type_id"], :name => "index_relationships_on_relationship_type_id"
  add_index "relationships", ["source_party_id"], :name => "index_relationships_on_source_party_id"
  add_index "relationships", ["target_party_id"], :name => "index_relationships_on_target_party_id"

  create_table "role_functions", :force => true do |t|
    t.integer  "role_id"
    t.integer  "function_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_functions", ["function_id"], :name => "index_role_functions_on_function_id"
  add_index "role_functions", ["role_id"], :name => "index_role_functions_on_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "searches", :force => true do |t|
    t.integer  "matter_id"
    t.string   "search_for"
    t.integer  "no_of_objects",  :limit => 2
    t.boolean  "express_search"
    t.date     "date_of_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["matter_id"], :name => "index_searches_on_matter_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "trademarks", :force => true do |t|
    t.date     "appl_date"
    t.string   "appl_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matter_id"
    t.string   "mark_name"
    t.string   "cfe_index"
    t.date     "application_date"
    t.string   "application_number"
    t.date     "priority_date"
    t.string   "ctm_number"
    t.string   "wipo_number"
    t.string   "reg_number"
    t.date     "registration_date"
    t.date     "renewal_date"
    t.string   "non_lv_reg_nr"
    t.date     "publication_date"
  end

  add_index "trademarks", ["matter_id"], :name => "index_trademarks_on_matter_id"

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

  add_index "user_filter_columns", ["column_name"], :name => "index_user_filter_columns_on_column_name"
  add_index "user_filter_columns", ["column_position"], :name => "index_user_filter_columns_on_column_position"
  add_index "user_filter_columns", ["column_query"], :name => "index_user_filter_columns_on_column_query"
  add_index "user_filter_columns", ["column_type"], :name => "index_user_filter_columns_on_column_type"
  add_index "user_filter_columns", ["user_filter_id"], :name => "index_user_filter_columns_on_user_filter_id"

  create_table "user_filters", :force => true do |t|
    t.integer  "user_id"
    t.string   "table_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_filters", ["table_name"], :name => "index_user_filters_on_table_name"
  add_index "user_filters", ["user_id"], :name => "index_user_filters_on_user_id"

  create_table "user_preferences", :force => true do |t|
    t.integer  "rows_per_page"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_preferences", ["user_id"], :name => "index_user_preferences_on_user_id"

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], :name => "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

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

  add_index "users", ["individual_id"], :name => "index_users_on_individual_id"

end
