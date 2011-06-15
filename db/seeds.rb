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
  admin_functions = ["FUNCT_LOGIN", "FUNCT_ADMIN_LINK", "FUNCT_CREATE_USER"] 
  functions = admin_functions 
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
end

RoleFunction.transaction do
  
  admin_functions = ["FUNCT_LOGIN", "FUNCT_ADMIN_LINK", "FUNCT_CREATE_USER"]
  role = Role.find_by_name("ROLE_ADMIN")  
  admin_functions.each do |function_name|
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
          :birth_date => Time.now, 
          :user_attributes => {
              :email => 'admin@petpat.lv', 
              :password_confirmation => 'administrator', 
              :password => 'administrator'
          }
      }
    }).individual.user.roles<<Role.find_by_name("ROLE_ADMIN")    
  end
  unless User.find_by_email("admin@petpat.lv").individual.party.contacts.where(:contact_value => "admin@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("admin@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "admin@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end
end