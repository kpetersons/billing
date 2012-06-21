class CreateFkIndexes < ActiveRecord::Migration
  def up

    add_index :accounts, :company_id, {:unique => false}

    add_index :addresses, :address_type_id, {:unique => false}
    add_index :addresses, :party_id, {:unique => false}
    add_index :addresses, :country_id, {:unique => false}
    add_index :addresses, :orig_id, {:unique => false}

    add_index :address_types, :party_id, {:unique => false}

    add_index :attorney_fee_types, :operating_party_id, {:unique => false}

    add_index :companies, :party_id, {:unique => false}
    add_index :companies, :orig_id, {:unique => false}

    add_index :contacts, :contact_type_id, {:unique => false}
    add_index :contacts, :party_id, {:unique => false}

    add_index :individuals, :party_id, {:unique => false}
    add_index :individuals, :gender_id, {:unique => false}

    add_index :customs, :matter_id, {:unique => false}
    add_index :customs, :client_all_ip_id, {:unique => false}

    add_index :customers, :party_id, {:unique => false}

    add_index :default_filters, :table_name, {:unique => true}

    add_index :default_filter_columns, :column_name, {:unique => false}
    add_index :default_filter_columns, :column_type, {:unique => false}
    add_index :default_filter_columns, :column_query, {:unique => false}
    add_index :default_filter_columns, :column_position, {:unique => false}
    add_index :default_filter_columns, :default_filter_id, {:unique => false}

    add_index :designs, :matter_id, {:unique => false}

    add_index :documents, :user_id, {:unique => false}
    add_index :documents, :parent_id, {:unique => false}

    add_index :document_tags, :document_id, {:unique => false}
    add_index :document_tags, :tag_id, {:unique => false}

    add_index :domains, :matter_id, {:unique => false}

    add_index :matter_clazzs, :matter_id, {:unique => false}
    add_index :matter_clazzs, :clazz_id, {:unique => false}

    add_index :functions, :name, {:unique => true}

    add_index :invoices, :customer_id, {:unique => false}
    add_index :invoices, :address_id, {:unique => false}
    add_index :invoices, :individual_id, {:unique => false}
    add_index :invoices, :currency_id, {:unique => false}
    add_index :invoices, :exchange_rate_id, {:unique => false}
    add_index :invoices, :invoice_status_id, {:unique => false}
    add_index :invoices, :matter_type_id, {:unique => false}

    add_index :invoice_lines, :official_fee_type_id, {:unique => false}
    add_index :invoice_lines, :attorney_fee_type_id, {:unique => false}

    add_index :invoice_line_presets, :operating_party_id, {:unique => false}
    add_index :invoice_line_presets, :official_fee_type_id, {:unique => false}
    add_index :invoice_line_presets, :attorney_fee_type_id, {:unique => false}
    add_index :invoice_line_presets, :author_id, {:unique => false}
    add_index :invoice_line_presets, :currency_id, {:unique => false}
    add_index :invoice_line_presets, :orig_id, {:unique => false}

    #add_index :invoice_matters, :matter_task_id, {:unique => false}
    #add_index :invoice_matters, :invoice_id, {:unique => false}

    add_index :invoice_statuses, :function_id, {:unique => false}

    add_index :invoice_status_flows, :revert_to_step_id, {:unique => false}
    add_index :invoice_status_flows, :current_step_id, {:unique => false}
    add_index :invoice_status_flows, :pass_to_step_id, {:unique => false}
    add_index :invoice_status_flows, :pass_to_function_id, {:unique => false}
    add_index :invoice_status_flows, :revert_to_function_id, {:unique => false}

    add_index :legals, :matter_id, {:unique => false}
    add_index :legals, :legal_type_id, {:unique => false}
    add_index :legals, :opposite_party_id, {:unique => false}
    add_index :legals, :opposite_party_agent_id, {:unique => false}

    add_index :linked_matters, :matter_id, {:unique => false}
    add_index :linked_matters, :linked_matter_id, {:unique => false}

    #add_index :matters, :document_id, {:unique => false}
    add_index :matters, :applicant_id, {:unique => false}
    add_index :matters, :agent_id, {:unique => false}
    #add_index :matters, :author_id, {:unique => false}
    add_index :matters, :matter_type_id, {:unique => false}
    add_index :matters, :operating_party_id, {:unique => false}
    add_index :matters, :matter_status_id, {:unique => false}
    add_index :matters, :orig_id, {:unique => false}

    add_index :matter_customers, :customer_id, {:unique => false}
    add_index :matter_customers, :matter_id, {:unique => false}
    add_index :matter_customers, :author_id, {:unique => false}

    add_index :matter_images, :matter_id, {:unique => false}

    add_index :matter_statuses, :function_id, {:unique => false}

    add_index :matter_status_flows, :revert_to_step_id, {:unique => false}
    add_index :matter_status_flows, :current_step_id, {:unique => false}
    add_index :matter_status_flows, :pass_to_step_id, {:unique => false}
    add_index :matter_status_flows, :pass_to_function_id, {:unique => false}
    add_index :matter_status_flows, :revert_to_function_id, {:unique => false}

    #add_index :matter_tasks, :matter_id, {:unique => false}
    add_index :matter_tasks, :matter_task_status_id, {:unique => false}
    add_index :matter_tasks, :author_id, {:unique => false}
    add_index :matter_tasks, :matter_task_type_id, {:unique => false}

    add_index :matter_task_statuses, :function_id, {:unique => false}
    add_index :matter_task_statuses, :name, {:unique => false}

    add_index :matter_task_status_flows, :revert_to_step_id, {:unique => false}
    add_index :matter_task_status_flows, :current_step_id, {:unique => false}
    add_index :matter_task_status_flows, :pass_to_step_id, {:unique => false}
    add_index :matter_task_status_flows, :pass_to_function_id, {:unique => false}
    add_index :matter_task_status_flows, :revert_to_function_id, {:unique => false}

    add_index :matter_task_types, :name, {:unique => false}

    add_index :matter_types, :function_id, {:unique => false}

    add_index :messages, :user_id, {:unique => false}

    add_index :official_fee_types, :operating_party_id, {:unique => false}

    add_index :operating_parties, :company_id, {:unique => false}
    add_index :operating_parties, :operating_party_id, {:unique => false}

    add_index :operating_party_matter_types, :operating_party_id, {:unique => false}
    add_index :operating_party_matter_types, :matter_type_id, {:unique => false}


    add_index :operating_party_users, :user_id, {:unique => false}
    add_index :operating_party_users, :operating_party_id, {:unique => false}

    add_index :parties, :orig_id, {:unique => false}

    add_index :patents, :matter_id,{:unique => false}

    add_index :patent_searches, :matter_id, {:unique => false}

    add_index :relationships, :source_party_id, {:unique => false}
    add_index :relationships, :target_party_id, {:unique => false}
    add_index :relationships, :relationship_type_id, {:unique => false}

    add_index :relationship_types, :name, {:unique => false}

    add_index :roles, :name, {:unique => false}

    add_index :role_functions, :role_id, {:unique => false}
    add_index :role_functions, :function_id, {:unique => false}

    add_index :searches, :matter_id, {:unique => false}

    add_index :tags, :name, {:unique => false}

    add_index :trademarks, :matter_id, {:unique => false}

    add_index :users, :individual_id, {:unique => false}

    add_index :user_filters, :user_id, {:unique => false}
    add_index :user_filters, :table_name, {:unique => false}

    add_index :user_filter_columns, :user_filter_id, {:unique => false}
    add_index :user_filter_columns, :column_name, {:unique => false}
    add_index :user_filter_columns, :column_type, {:unique => false}
    add_index :user_filter_columns, :column_query, {:unique => false}
    add_index :user_filter_columns, :column_position, {:unique => false}

    add_index :user_preferences, :user_id, {:unique => false}

    add_index :user_roles, :user_id, {:unique => false}
    add_index :user_roles, :role_id, {:unique => false}

  end

  def down
    remove_index :accounts, :company_id

    remove_index :address, :address_type_id
    remove_index :address, :party_id
    remove_index :address, :country_id
    remove_index :address, :orig_id

    remove_index :address_types, :party_id

    remove_index :attorney_fee_types, :operating_party

    remove_index :company, :party_id
    remove_index :company, :orig_id

    remove_index :contacts, :contact_type_id
    remove_index :contacts, :party_id

    remove_index :individuals, :party_id
    remove_index :individuals, :gender_id

    remove_index :customs, :matter_id
    remove_index :customs, :client_all_ip_id

    remove_index :customers, :party_id

    remove_index :default_filters, :table_name

    remove_index :default_filter_columns, :column_name
    remove_index :default_filter_columns, :column_type
    remove_index :default_filter_columns, :column_query
    remove_index :default_filter_columns, :column_position
    remove_index :default_filter_columns, :default_filter_id

    remove_index :designs, :matter_id

    remove_index :documents, :user_id
    remove_index :documents, :parent_id

    remove_index :documents_tags, :document_id
    remove_index :documents_tags, :tag_id

    remove_index :domains, :matter_id

    remove_index :matter_clazzs, :matter_id
    remove_index :matter_clazzs, :clazz_id

    remove_index :functions, :name

    remove_index :invoices, :document_id
    remove_index :invoices, :customer_id
    remove_index :invoices, :address_id
    remove_index :invoices, :individual_id
    remove_index :invoices, :currency_id
    remove_index :invoices, :exchange_rate_id
    remove_index :invoices, :invoice_status_id
    remove_index :invoices, :matter_type_id

    remove_index :invoice_lines, :invoice_id
    remove_index :invoice_lines, :official_fee_type_id
    remove_index :invoice_lines, :attorney_fee_type_id

    remove_index :invoice_line_presets, :operating_party_id
    remove_index :invoice_line_presets, :official_fee_type_id
    remove_index :invoice_line_presets, :attorney_fee_type_id
    remove_index :invoice_line_presets, :author_id
    remove_index :invoice_line_presets, :currency_id
    remove_index :invoice_line_presets, :orig_id

    remove_index :invoice_matters, :matter
    remove_index :invoice_matters, :matter_task
    remove_index :invoice_matters, :invoice_id

    remove_index :invoice_statuses, :function_id

    remove_index :invoice_status_flows, :revert_to_step_id
    remove_index :invoice_status_flows, :current_step_id
    remove_index :invoice_status_flows, :pass_to_step_id
    remove_index :invoice_status_flows, :pass_to_function_id
    remove_index :invoice_status_flows, :revert_to_function_id

    remove_index :legals, :matter_id
    remove_index :legals, :legal_type_id
    remove_index :legals, :opposite_party_id
    remove_index :legals, :opposite_party_agent_id

    remove_index :linked_matters, :matter_id
    remove_index :linked_matters, :linked_matter_id

    remove_index :matters, :document_id
    remove_index :matters, :applicant_id
    remove_index :matters, :agent_id
    remove_index :matters, :author_id
    remove_index :matters, :matter_type_id
    remove_index :matters, :operating_party_id
    remove_index :matters, :matter_status_id
    remove_index :matters, :orig_id

    remove_index :matter_customers, :customer_id
    remove_index :matter_customers, :matter_id
    remove_index :matter_customers, :author_id

    remove_index :matter_images, :matter_id

    remove_index :matter_statuses, :function_id

    remove_index :matter_status_flows, :revert_to_step_id
    remove_index :matter_status_flows, :current_step_id
    remove_index :matter_status_flows, :pass_to_step_id
    remove_index :matter_status_flows, :pass_to_function_id
    remove_index :matter_status_flows, :revert_to_function_id

    remove_index :matter_tasks, :matter_id
    remove_index :matter_tasks, :matter_task_status_id
    remove_index :matter_tasks, :author_id
    remove_index :matter_tasks, :matter_task_type_id

    remove_index :matter_task_statuses, :function_id
    remove_index :matter_task_statuses, :name

    remove_index :matter_task_status_flows, :revert_to_step_id
    remove_index :matter_task_status_flows, :current_step_id
    remove_index :matter_task_status_flows, :pass_to_step_id
    remove_index :matter_task_status_flows, :pass_to_function_id
    remove_index :matter_task_status_flows, :revert_to_function_id

    remove_index :matter_task_types, :name

    remove_index :matter_types, :function_id

    remove_index :messages, :user_id

    remove_index :official_fee_types, :operating_party_id

    remove_index :operating_parties, :company_id
    remove_index :operating_parties, :operating_party_id

    remove_index :operating_party_matter_types, :operating_party_id
    remove_index :operating_party_matter_types, :matter_type_id


    remove_index :operating_party_users, :user_id
    remove_index :operating_party_users, :operating_party_id

    remove_index :parties, :orig_id

    remove_index :patents, :matter_id

    remove_index :patent_searches, :matter_id

    remove_index :relationships, :source_party_id
    remove_index :relationships, :target_party_id
    remove_index :relationships, :relationship_type_id

    remove_index :relationship_types, :name

    remove_index :roles, :name

    remove_index :role_functions, :role_id
    remove_index :role_functions, :function_id

    remove_index :searches, :matter_id

    remove_index :tags, :name

    remove_index :trademarks, :matter_id

    remove_index :users, :individual_id

    remove_index :user_filters, :user_id
    remove_index :user_filters, :table_name

    remove_index :user_filter_columns, :user_filter_id
    remove_index :user_filter_columns, :column_name
    remove_index :user_filter_columns, :column_type
    remove_index :user_filter_columns, :column_query
    remove_index :user_filter_columns, :column_position

    remove_index :user_preferences, :user_id

    remove_index :user_roles, :user_id
    remove_index :user_roles, :role_id
  end
end
