namespace :db do
  desc "Fill database with sample users"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke    
    50.times do |i|     
      party = Party.new({
        :identifier => "identifier#{i}", 
        :individual_attributes => {
            :first_name => "First name #{i}", 
            :last_name => "Last name #{i}", 
            :birth_date => Date.today, 
            :user_attributes => {
                :email => "email#{i}@petpat.lv", 
                :password_confirmation => 'password', 
                :password => 'password',
                :registration_date => Date.today,
                :active => true,
                :blocked => false
            }
        }
      })
      party.save
      party.individual.user.roles<<Role.find_all_by_name(["ROLE_ADMIN", "ROLE_MIMINAL"])      
      user = User.find_by_email("email#{i}@petpat.lv").individual.party
      4.times do |j|      
        user.contacts<<Contact.create(:contact_value => "email#{i}#{j}@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
        user.contacts<<Contact.create(:contact_value => "294585#{i}#{j}", :contact_type_id => ContactType.find_by_name("CT_PHONE").id)      
        user.contacts<<Contact.create(:contact_value => "284585#{i}#{j}", :contact_type_id => ContactType.find_by_name("CT_FAX").id)
      end      
      4.times do |j|
        user.addresses<<Address.create(:country => "BCountry #{i}#{j}", :city => "BCity #{i}#{j}", :street => "BStreet #{i}#{j}", :house_number => "BHouse number #{i}#{j}", :address_type_id => AddressType.find_by_name('BILL_TO'))                
        user.addresses<<Address.create(:country => "SCountry #{i}#{j}", :city => "SCity #{i}#{j}", :street => "SStreet #{i}#{j}", :house_number => "SHouse number #{i}#{j}", :address_type_id => AddressType.find_by_name('SHIP_TO'))      
        user.addresses<<Address.create(:country => "CCountry #{i}#{j}", :city => "CCity #{i}#{j}", :street => "CStreet #{i}#{j}", :house_number => "CHouse number #{i}#{j}", :address_type_id => AddressType.find_by_name('CONTACT_TO'))      
      end      
    end
    50.times do |i|     
      party = Party.new({
        :identifier => "identifier#{i*10}", 
        :company_attributes => {
          :name => "Customer #{i}"
        },        
        :customer_attributes => {
          :customer_since => Date.today,
          :customer_type => "COMPANY"
        }
      })
      party.save
      puts "party id #{party.id} errors #{party.errors}"
      4.times do |j|      
        party.contacts<<Contact.create(:contact_value => "email#{i}#{j}@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
        party.contacts<<Contact.create(:contact_value => "294585#{i}#{j}", :contact_type_id => ContactType.find_by_name("CT_PHONE").id)      
        party.contacts<<Contact.create(:contact_value => "284585#{i}#{j}", :contact_type_id => ContactType.find_by_name("CT_FAX").id)
      end      
      4.times do |j|
        party.addresses<<Address.create(:country => "BCountry #{i}#{j}", :city => "BCity #{i}#{j}", :street => "BStreet #{i}#{j}", :house_number => "BHouse number #{i}#{j}", :address_type_id => AddressType.find_by_name('BILL_TO'))                
        party.addresses<<Address.create(:country => "SCountry #{i}#{j}", :city => "SCity #{i}#{j}", :street => "SStreet #{i}#{j}", :house_number => "SHouse number #{i}#{j}", :address_type_id => AddressType.find_by_name('SHIP_TO'))      
        party.addresses<<Address.create(:country => "CCountry #{i}#{j}", :city => "CCity #{i}#{j}", :street => "CStreet #{i}#{j}", :house_number => "CHouse number #{i}#{j}", :address_type_id => AddressType.find_by_name('CONTACT_TO'))      
      end      
    end    
  end
end