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

ActiveRecord::Schema.define(:version => 20110706071025) do

  create_table "address_types", :force => true do |t|
    t.string   "name"
    t.boolean  "built_in"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.integer  "party_id"
    t.integer  "address_type_id"
    t.string   "country"
    t.string   "city"
    t.string   "street"
    t.string   "house_number"
    t.string   "room_number"
    t.string   "post_code"
    t.string   "po_box"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attorney_fee_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "currencies", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.integer  "party_id"
    t.date     "customer_since"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_type"
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
    t.string   "official_fee"
    t.string   "attorney_fee"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_lines", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "official_fee_type_id"
    t.string   "official_fee"
    t.string   "attorney_fee"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attorney_fee_type_id"
  end

  create_table "invoice_matters", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "matter_id"
    t.integer  "matter_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "matter_clazzs", :force => true do |t|
    t.integer  "matter_id"
    t.integer  "clazz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matter_task_statuses", :force => true do |t|
    t.string   "name"
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
  end

  create_table "official_fee_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operating_parties", :force => true do |t|
    t.integer  "company_id"
    t.integer  "operating_party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", :force => true do |t|
    t.string   "identifier"
    t.string   "party_type"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "tags", :force => true do |t|
    t.string   "name"
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
  end

end
