class AddColumnToMatter1 < ActiveRecord::Migration
  def self.up
    #    
    
		add_column :trademarks, :mark_name, :string
    add_column :trademarks, :description, :string
    add_column :trademarks, :cfe_index, :string   
    add_column :trademarks, :application_date, :date    
    add_column :trademarks, :application_number, :string    
    add_column :trademarks, :priority_date, :date
    add_column :trademarks, :ctm_number, :string    
    add_column :trademarks, :wipo_number, :string    
    add_column :trademarks, :reg_number, :string
    #
    
    add_column :patents, :application_number,  :string    
    add_column :patents, :application_date,  :date    
    add_column :patents, :patent_number, :string    
    add_column :patents, :patent_grant_date, :date    
    add_column :patents, :ep_appl_number, :string    
    add_column :patents, :ep_number, :string
    #
    
    add_column :designs, :description, :string    
    add_column :designs, :application_number,  :string    
    add_column :designs, :application_date,  :date    
    add_column :designs, :design_number, :string    
    add_column :designs, :rdc_appl_number, :string    
    add_column :designs, :rdc_number,  :string
    #
    
    add_column :legals, :opposed_marks, :string    
    add_column :legals, :description, :string    
    add_column :legals, :type,  :integer    
    add_column :legals, :instance,  :string    
    add_column :legals, :opposite_party,  :integer    
    add_column :legals, :opposite_party_agent,  :integer    
    add_column :legals, :date_of_closure, :date
    #
    add_column :customs, :description, :string
    add_column :customs, :date_of_order_alert, :date
    add_column :customs, :ca_application_date, :date
    add_column :customs, :ca_application_number, :string
    add_column :customs, :client_all_ip, :integer

  end

  def self.down
    remove_column :trademarks, :mark_name
    remove_column :trademarks, :description
    remove_column :trademarks, :cfe_index, :string
    remove_column :trademarks, :application_date
    remove_column :trademarks, :application_number
    remove_column :trademarks, :priority_date
    remove_column :trademarks, :ctm_number
    remove_column :trademarks, :wipo_number
    remove_column :trademarks, :reg_number
    #
    remove_column :patents, :application_number
    remove_column :patents, :application_date
    remove_column :patents, :patent_number
    remove_column :patents, :patent_grant_date
    remove_column :patents, :ep_appl_number
    remove_column :patents, :ep_number
    #
    remove_column :designs, :description
    remove_column :designs, :application_number
    remove_column :designs, :application_date
    remove_column :designs, :design_number
    remove_column :designs, :rdc_appl_number
    remove_column :designs, :rdc_number
    #
    remove_column :legals, :opposed_marks
    remove_column :legals, :description
    remove_column :legals, :type
    remove_column :legals, :instance
    remove_column :legals, :opposite_party
    remove_column :legals, :opposite_party_agent
    remove_column :legals, :date_of_closure

    remove_column :customs, :description
    remove_column :customs, :date_of_order_alert
    remove_column :customs, :ca_application_date
    remove_column :customs, :ca_application_number
    remove_column :customs, :client_all_ip
  end
end
