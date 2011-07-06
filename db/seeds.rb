# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

RelationshipType.transaction do
  unless RelationshipType.find_by_name('CONTACT_PERSON')
    RelationshipType.create(:name => 'CONTACT_PERSON', :built_in => true)
  end
end

MatterTaskStatus.transaction do
  matter_task_statuses = ["MTS_NEW", "MTS_SETTLED", "MTS_HOT"]
  matter_task_statuses.each do |matter_task_statuss_name|
    unless MatterTaskStatus.find_by_name(matter_task_statuss_name)
      MatterTaskStatus.create(:name => matter_task_statuss_name)
    end  
  end
end

AddressType.transaction do
  address_types = ["BILL_TO", "SHIP_TO", "CONTACT_TO"]
  address_types.each do |address_type_name|
    unless AddressType.find_by_name(address_type_name)
      AddressType.create(:name => address_type_name, :built_in => true)
    end    
  end
end

Function.transaction do
  functions = [
    "FUNCT_LOGIN", 
    "FUNCT_DASHBOARD_LINK", 
    "FUNCT_MATTERS_LINK", 
    "FUNCT_INVOICES_LINK", 
    "FUNCT_CUSTOMERS_LINK",
    "FUNCT_SETTINGS_LINK",
    "FUNCT_ADMIN_LINK", 
    "FUNCT_CREATE_USER", 
    "FUNCT_CREATE_ROLE", 
    "FUNCT_ADD_ROLE",
    "FUNCT_ADD_FUNCTION",
    "FUNCT_CREATE_MATTER",
    "FUNCT_CREATE_INVOICE",    
    "FUNCT_CREATE_CUSTOMER",
    "FUNCT_CREATE_EXCHANGE_RATE",
    "FUNCT_ACTIVATE_USER",
    "FUNCT_BLOCK_USER"
  ]  
  functions.each do |function_name|
    unless Function.find_by_name(function_name)
      Function.create(:name => function_name, :description => "#{function_name}_DESCR")
    end
  end
end

Role.transaction do
  unless Role.find_by_name("ROLE_ADMIN")
    Role.create(:name => "ROLE_ADMIN", :description => "ROLE_ADMIN_DESCR")
  end  
  unless Role.find_by_name("ROLE_MIMINAL")
    Role.create(:name => "ROLE_MIMINAL", :description => "ROLE_MIMINAL_DESCR")
  end
  unless Role.find_by_name("ROLE_MATTER_MANAGER")
    Role.create(:name => "ROLE_MATTER_MANAGER", :description => "ROLE_MATTER_MANAGER_DESCR")
  end
  unless Role.find_by_name("ROLE_CUSTOMER_MANAGER")
    Role.create(:name => "ROLE_CUSTOMER_MANAGER", :description => "ROLE_MATTER_MANAGER_DESCR")
  end  
end

RoleFunction.transaction do
  admin_functions = ["FUNCT_ADMIN_LINK", "FUNCT_CREATE_USER", "FUNCT_CREATE_ROLE", "FUNCT_ADD_ROLE", "FUNCT_ADD_FUNCTION", "FUNCT_CREATE_EXCHANGE_RATE", "FUNCT_ACTIVATE_USER", "FUNCT_BLOCK_USER"]
  
  role = Role.find_by_name("ROLE_ADMIN")  
  admin_functions.each do |function_name|
    unless role.functions.where(:name => function_name).first
      role.functions<<Function.find_by_name(function_name)
    end         
  end 
  
  minimal_functions = ["FUNCT_LOGIN", "FUNCT_DASHBOARD_LINK"]
  role = Role.find_by_name("ROLE_MIMINAL")  
  minimal_functions.each do |function_name|
    unless role.functions.where(:name => function_name).first
      role.functions<<Function.find_by_name(function_name)
    end         
  end

  matter_functions = ["FUNCT_MATTERS_LINK"]
  role = Role.find_by_name("ROLE_MATTER_MANAGER")  
  matter_functions.each do |function_name|
    unless role.functions.where(:name => function_name).first
      role.functions<<Function.find_by_name(function_name)
    end         
  end
  
  matter_functions = ["FUNCT_CUSTOMERS_LINK"]
  role = Role.find_by_name("ROLE_CUSTOMER_MANAGER")  
  matter_functions.each do |function_name|
    unless role.functions.where(:name => function_name).first
      role.functions<<Function.find_by_name(function_name)
    end         
  end  
end

ContactType.transaction do  
  contact_types = ["CT_E-MAIL", "CT_PHONE", "CT_FAX"]
  contact_types.each do |contact_type_name|
    unless ContactType.find_by_name(contact_type_name)
      ContactType.create(:name => contact_type_name, :built_in => true)
    end  
  end  
end

User.transaction do
  unless User.find_by_email("admin@petpat.lv")
    Party.create({
      :identifier => '-', 
      :individual_attributes => {
          :first_name => 'System', 
          :last_name => 'Admin', 
          :birth_date => Date.today, 
          :user_attributes => {
              :email => 'admin@petpat.lv', 
              :password_confirmation => 'administrator', 
              :password => 'administrator',
              :registration_date => Date.today,
              :active => true,
              :blocked => false
          }
      }
    }).individual.user.roles<<Role.find_all_by_name(["ROLE_ADMIN", "ROLE_MIMINAL"])
    
  end
  unless User.find_by_email("admin@petpat.lv").individual.party.contacts.where(:contact_value => "admin@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("admin@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "admin@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end
end

Clazz.transaction do
  (1..45).each do |i|
    if Clazz.find_by_code(i).nil?
      Clazz.create(:code => i, :name => "#{i}_DESCR")
    end
  end
end

Currency.transaction do
  ["EUR", "LVL", "USD"].each do |i|
    if Currency.find_by_code(i).nil?
      Currency.create(:code => i, :name => i)
    end
  end
end

ExchangeRate.transaction do
  Currency.all.each do |currency|
    if ExchangeRate.find_by_currency_id(currency.id).nil?
      ExchangeRate.create(:currency_id => currency.id, :rate => 1.0, :from_date => Date.today-365)      
    end    
  end
end

InvoiceLine.transaction do
  InvoiceLine.delete_all
end