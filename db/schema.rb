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

ActiveRecord::Schema.define(:version => 20111208141632) do

    execute <<-SQL
      drop view if exists v_invoices;
    SQL

    execute <<-SQL
      drop view if exists v_matters;
    SQL

    execute <<-SQL
      drop view if exists v_matter_tasks;
    SQL

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


    execute <<-SQL
      create view v_invoices as (
select
   case invoice_type when 0 then to_char(invoice_date, 'YY')||'/'|| registration_number else registration_number::text end as registration_number,
   operating_party_id,
   id,
   author_id,
   customer_name,
   person,
   address,
   currency,
   author,
   status,
   our_ref,
   your_ref,
   your_date,
   invoice_date,
   payment_term,
   discount,
   po_billing,
   subject,
   ending_details,
   created_at,
   updated_at,
   rate,
   apply_vat,
   date_paid,
   trunc(round(total_official_fee, 2), 2) as total_official_fee,
   trunc(round(total_attorney_fee, 2), 2) as total_attorney_fee,
   trunc(round(total_attorney_fee + total_official_fee, 2), 2) as subtotal,
   trunc(round(case apply_vat when true then (total_attorney_fee + total_official_fee) * 0.22 else 0 end, 2), 2)  as total_vat,
   trunc(round(case apply_vat when true then (total_attorney_fee + total_official_fee) * 1.22 else (total_attorney_fee + total_official_fee) end, 2), 2) as grand_total
from (
	select
	  author.operating_party_id,
	        i.id,
	        i.author_id,
	        cust.name as customer_name,
	        pers.first_name || ' ' || pers.last_name as person,
	        replace(addr.country || ', ' || addr.city || ', ' || addr.street || ', ' || addr.house_number || ', ' || addr.room_number || ', ' || addr.post_code || ', ' || addr.po_box, ', ,', '') as address,
	        curr.currency,
	        ai.first_name || ' ' || ai.last_name as author,
	        iss.name as status,
	        i.our_ref,
	        i.your_ref,
	        i.your_date,
	        i.invoice_date,
	        i.payment_term,
	        i.discount,
	        i.po_billing,
	        i.subject,
	        i.ending_details,
	        i.created_at,
	        i.updated_at,
	        er.rate,
	        i.apply_vat,
	        i.date_paid,
	        il.total_official_fee,
	        il.total_attorney_fee - coalesce(nullif(il.total_attorney_fee/100*i.discount, 0), 0) as total_attorney_fee,
	        doc.registration_number,
	        i.invoice_type
	      from
	        invoices i	left outer join (
	                  select p.id as party_id, c.id, co.name from customers c, parties p, companies co where c.party_id = p.id and p.id = co.party_id
	                    ) cust on i.customer_id = cust.id
	              left outer join (
	                  select i.id, i.first_name,  i.last_name from individuals i
	                    ) pers on i.individual_id = pers.id
	              left outer join (
	                  select c.name as country, a.city, a.street, a.house_number, a.room_number, a.post_code, a.po_box, a.party_id  from addresses a left outer join countries c on c.id = a.country_id
	                    ) addr on addr.party_id = i.address_id
	              left outer join (
	                  select curr.name as currency, curr.id  from currencies curr
	                    ) curr on i.currency_id = curr.id
	              left outer join (
	                  select * from exchange_rates
	                    ) er on i.exchange_rate_id = er.id and er.currency_id = i.currency_id
	              left outer join (
	              		select invoice_id, sum(total_official_fee) as total_official_fee, sum(total_attorney_fee) as total_attorney_fee from (
	              		select invoice_id,
	              		sum(total_official_fee) as total_official_fee,
	              		sum(total_attorney_fee) as total_attorney_fee
	              		from invoice_lines group by invoice_id, total_discount, items
	              		) k group by invoice_id) il on il.invoice_id = i.id,
	        users author,
	        individuals ai,
	        invoice_statuses iss,
	        documents doc
	      where
	        i.author_id = author.id and
	        author.individual_id = ai.id and
	        iss.id = i.invoice_status_id and
	        doc.id = i.document_id
	      order by i.id) a
);
    SQL


    execute <<-SQL
      create view v_matters as (
      select
        ma.operating_party_id,
        ma.agent_id,
        ma.applicant_id,
        ma.id,
        author.id as author_id,
        doc.parent_id,
        doc.registration_number,
        doc.description,
        doc.created_at,
        doc.updated_at,
        doc.notes,
        appl_company.name as applicant,
        agent_company.name as agent,
        author_individual.first_name || ' ' || author_individual.last_name as author,
        op_company.name as operating_party,
        mt.name as matter_type,
        ms.name as matter_status,
        t.wipo_number,
        t.priority_date,
        t.mark_name,
        t.ctm_number,
        t.cfe_index,
        COALESCE (t.appl_number,p.application_number,d.application_number) as application_number,
        COALESCE (t.appl_date, p.application_date, d.application_date) as application_date,
        p.patent_number,
        p.patent_grant_date,
        p.ep_appl_number,
        p.ep_number,
        d.design_number,
        d.rdc_appl_number,
        d.rdc_number,
        l.opposed_marks,
        l.instance,
        l.date_of_closure,
        l.opposite_party,
        l.opposite_party_agent,
        l.legal_type,
        c.date_of_order_alert,
        c.ca_application_date,
        c.ca_application_number,
        c.name as client_all_ip,
        ps.patent_eq_numbers,
        ps.no_of_patents,
        COALESCE (ps.date_of_order, s.date_of_order) as date_of_order,
        s.search_for,
        s.no_of_objects,
        s.express_search,
        dm.domain_name,
        dm.registration_date
      from
        documents doc,
        matters ma left outer join trademarks t on ma.id = t.matter_id
        left outer join patents p 			on ma.id = p.matter_id
        left outer join designs d 			on ma.id = d.matter_id
        left outer join (
                select
                  l.opposed_marks,
                  l.instance,
                  l.date_of_closure,
                  l.opposite_party_id,
                  l.opposite_party_agent_id,
                  lt.name as legal_type,
                  cop.name as opposite_party,
                  copa.name as opposite_party_agent,
                  l.matter_id
                from
                  legals l 	left outer join (select cop.id, coop.name from customers cop, parties pop, companies coop where cop.party_id = pop.id and pop.id = coop.party_id) cop on l.opposite_party_id = cop.id
                      left outer join (select copa.id, coopa.name from customers copa, parties popa, companies coopa where copa.party_id = popa.id and popa.id = coopa.party_id) copa on l.opposite_party_agent_id = copa.id	,
                  legal_types lt
                where
                  l.legal_type_id = lt.id
        ) l on ma.id = l.matter_id
        left outer join (
                select
                  c.date_of_order_alert,
                  c.ca_application_date,
                  c.ca_application_number,
                  copaip.name,
                  c.matter_id
                from
                  customs c left outer join customers caip on c.client_all_ip_id = caip.id, parties paip, companies copaip where paip.id = caip.party_id and copaip.party_id = paip.id) c on ma.id = c.matter_id
        left outer join patent_searches ps 	on ma.id = ps.matter_id
        left outer join searches s 			on ma.id = s.matter_id
        left outer join domains dm 			on ma.id = dm.matter_id,
        customers applicant,
        parties appl_party,
        companies appl_company,
        customers agent,
        parties agent_party,
        companies agent_company,
        users author,
        individuals author_individual,
        matter_types mt,
        operating_parties op,
        companies op_company,
        matter_statuses ms
      where
        doc.id = ma.document_id and
        ma.matter_type_id = mt.id and
        ma.matter_status_id = ms.id and
        ma.author_id = author.id and
        ma.applicant_id = applicant.orig_id and
        ma.agent_id = agent.orig_id and
        ma.operating_party_id = op.id and
        author.individual_id = author_individual.id and
        applicant.party_id = appl_party.id and
        agent.party_id = agent_party.id and
        applicant.date_effective_end is null and
        agent.date_effective_end is null and
        appl_party.id = appl_company.party_id and
        agent_party.id = agent_company.party_id and
        op.company_id = op_company.id
      order by ma.id
      );
    SQL


    execute <<-SQL
      create view v_matter_tasks as (
        select
          mt.id,
          mt.matter_id,
          m.registration_number,
          m.matter_type,
          mtt.name as task_type,
          mts.name as status,
          substring(mt.description from 1 for 150) as description,
          mt.proposed_deadline as deadline,
          mt.created_at,
          mt.updated_at
        from
          matter_tasks mt,
          v_matters m,
          matter_task_statuses mts,
          matter_task_types mtt
        where
          mt.matter_id = m.id
          and mts.id = mt.matter_task_status_id
          and mtt.id = mt.matter_task_type_id
      );
    SQL
end
