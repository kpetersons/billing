# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Gender.transaction do
  genders = ["gender.male", "gender.female", "gender.n_a"]
  genders.each do |gender|
    Gender.create(:name => gender) unless Gender.find_by_name(gender)
  end
end

RelationshipType.transaction do
  unless RelationshipType.find_by_name('CONTACT_PERSON')
    RelationshipType.create(:name => 'CONTACT_PERSON', :built_in => true)
  end
end

MatterTaskStatus.transaction do
  prefix = "matter.task.status."
  matter_task_statuses = [
    ["re_open",              "open",              "pass_open"],
    ["re_awaiting_response", "awaiting_response", "pass_awaiting_response"],
    ["re_done",              "done",              "pass_done"],
    ["re_canceled",          "canceled",          "pass_canceled"]]
  matter_task_statuses.each do |name|
    unless MatterTaskStatus.find_by_name(name[0])
      MatterTaskStatus.create(:revert_to_name => "#{prefix}#{name[0]}", :name => "#{prefix}#{name[1]}", :pass_to_name => "#{prefix}#{name[2]}")
    end
  end
end

MatterTaskStatusFlow.transaction do
  prefix = "matter.task.status."
  open = MatterTaskStatus.find_by_name("#{prefix}open")
  awaiting_response = MatterTaskStatus.find_by_name("#{prefix}awaiting_response")
  done = MatterTaskStatus.find_by_name("#{prefix}done")
  canceled = MatterTaskStatus.find_by_name("#{prefix}canceled")

  MatterTaskStatusFlow.delete_all

  # 1 * <->                 Open <->              Awaiting response  start state
  # 2 * <->                 Open <->              Canceled
  # 3 Open <->              Awaiting response <-> Done
  # 4 Open <->              Canceled <->          *
  # 5 Open <->              Awaiting response <-> Canceled
  # 6 Awaiting response <-> Done <->              *
  # 7 Awaiting response <-> Canceled <->          *

  #1
  i = MatterTaskStatusFlow.create(
  :revert_to_step_id => nil,
  :current_step_id   => open.id,
  :pass_to_step_id   => awaiting_response.id, :start_state => true)
  #2
  MatterTaskStatusFlow.create(
  :revert_to_step_id => nil,
  :current_step_id   => open.id,
  :pass_to_step_id   => canceled.id)
  #3
  MatterTaskStatusFlow.create(
  :revert_to_step_id => open.id,
  :current_step_id   => awaiting_response.id,
  :pass_to_step_id   => done.id)
  #4
  MatterTaskStatusFlow.create(
  :revert_to_step_id => open.id,
  :current_step_id   => canceled.id,
  :pass_to_step_id   => nil)
  #5
  MatterTaskStatusFlow.create(
  :revert_to_step_id => open.id,
  :current_step_id   => awaiting_response.id,
  :pass_to_step_id   => canceled.id)
  #6
  MatterTaskStatusFlow.create(
  :revert_to_step_id => awaiting_response.id,
  :current_step_id   => done.id,
  :pass_to_step_id   => nil)
  #7
  MatterTaskStatusFlow.create(
  :revert_to_step_id => awaiting_response.id,
  :current_step_id   => canceled.id,
  :pass_to_step_id   => nil)
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
  roles = ["ROLE_MIMINAL", "ROLE_ADMIN", "ROLE_MATTER_MANAGER", "ROLE_INVOICES_MANAGER", "ROLE_CUSTOMER_MANAGER"]
  roles.each do |role|
    unless Role.find_by_name(role)
      Role.create(:name => role, :description => "#{role}_DESCR")
    end
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

  matter_functions = ["FUNCT_INVOICES_LINK"]
  role = Role.find_by_name("ROLE_INVOICES_MANAGER")
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


OperatingParty.transaction do
  operating_parties = ["party.operating.petpat"]
  operating_parties.each do |operating_party|
    if Company.find_by_name(operating_party).nil?
      @result = Party.new({
        :identifier => UUIDTools::UUID.random_create.to_s,
        :party_type => 'party company operating',
        :company_attributes => {
          :name => operating_party,
          :operating_party_attributes => {
            :operating_party_id => nil
          }
        }
      })
      puts "@result.errors #{@result.errors}"
    @result.save
    end
  end
end

@main_party = Company.find_by_name("party.operating.petpat").party

OperatingParty.transaction do
  operating_parties = ["party.operating.administration", "party.operating.trademark", "party.operating.patent", "party.operating.legal"]
  operating_parties.each do |operating_party_name|
    if Company.find_by_name(operating_party_name).nil?
      @party = Party.new({
        :identifier => UUIDTools::UUID.random_create.to_s,
        :party_type => 'party company operating',
        :company_attributes => {
          :name => operating_party_name,
          #       :registration_number => 'N/A',
          :operating_party_attributes => {
            :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id
          }
        }
      })
      puts @party.errors
    @party.save
    end
  end
end

User.transaction do
  unless User.find_by_email("admin@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'System',
        :last_name => 'Admin',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'admin@petpat.lv',
          :password_confirmation => 'administrator',
          :password => 'administrator',
          :registration_date => Date.today,
          :initials => "ADMIN",
          :active => true,
          :blocked => false,
          :operating_party_id => @main_party.company.operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

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

MatterType.transaction do
  matter_types = ["matter.trademark", "matter.patent", "matter.legal", "matter.design", "matter.custom"]
  matter_types.each  do |matter_type|
    MatterType.create(:name => matter_type, :description => "#{matter_type}_DESC") unless !MatterType.find_by_name(matter_type).nil?
  end
end

OperatingPartyMatterType.transaction do
  operating_parties = ["party.operating.administration", "party.operating.trademark", "party.operating.patent", "party.operating.legal"]
  #
  OperatingPartyMatterType.delete_all
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.trademark").id,
  :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.patent").id,
  :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.design").id,
  :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.legal").id,
  :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  #
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.trademark").id,
  :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.patent").id,
  :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.design").id,
  :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.legal").id,
  :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  #
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.trademark").id,
  :operating_party_id => Company.find_by_name("party.operating.trademark").operating_party.id)
  #
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.patent").id,
  :operating_party_id => Company.find_by_name("party.operating.patent").operating_party.id)
  #
  OperatingPartyMatterType.create(
  :matter_type_id => MatterType.find_by_name("matter.legal").id,
  :operating_party_id => Company.find_by_name("party.operating.legal").operating_party.id)
end

User.transaction do

  unless User.find_by_email("armins.petersons@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Armins',
        :last_name => 'Petersons',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'armins.petersons@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "AP",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("armins.petersons@petpat.lv").individual.party.contacts.where(:contact_value => "armins.petersons@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("armins.petersons@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "armins.petersons@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("brigita.petersone@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Brigita',
        :last_name => 'Petersone',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'brigita.petersone@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "BP",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("brigita.petersone@petpat.lv").individual.party.contacts.where(:contact_value => "brigita.petersone@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("brigita.petersone@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "brigita.petersone@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("andrejs.petersons@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Andrejs',
        :last_name => 'Petersons',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'andrejs.petersons@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "AnP",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("andrejs.petersons@petpat.lv").individual.party.contacts.where(:contact_value => "andrejs.petersons@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("andrejs.petersons@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "andrejs.petersons@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("ieva.stala@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Ieva',
        :last_name => 'Stala',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'ieva.stala@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :initials => "ID",
          :registration_date => Date.today,
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.trademark").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("ieva.stala@petpat.lv").individual.party.contacts.where(:contact_value => "ieva.stala@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("ieva.stala@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "ieva.stala@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("katrina.sole@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Katrina',
        :last_name => 'Sole',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'katrina.sole@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "KS",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.trademark").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("katrina.sole@petpat.lv").individual.party.contacts.where(:contact_value => "katrina.sole@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("katrina.sole@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "katrina.sole@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("lucija.kuzjukevica@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Lucija',
        :last_name => 'Kuzjukevica',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'lucija.kuzjukevica@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "LK",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.patent").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("lucija.kuzjukevica@petpat.lv").individual.party.contacts.where(:contact_value => "lucija.kuzjukevica@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("lucija.kuzjukevica@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "lucija.kuzjukevica@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("sandra.kumaceva@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Sandra',
        :last_name => 'Kumaceva',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'sandra.kumaceva@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "SK",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.patent").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("sandra.kumaceva@petpat.lv").individual.party.contacts.where(:contact_value => "sandra.kumaceva@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("sandra.kumaceva@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "sandra.kumaceva@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("artis.kromanis@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Artis',
        :last_name => 'Kromanis',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'artis.kromanis@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "AK",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.patent").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("artis.kromanis@petpat.lv").individual.party.contacts.where(:contact_value => "artis.kromanis@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("artis.kromanis@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "artis.kromanis@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("gatis.merzvinskis@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Gatis',
        :last_name => 'Merzvinskis',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'gatis.merzvinskis@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "GM",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.legal").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("gatis.merzvinskis@petpat.lv").individual.party.contacts.where(:contact_value => "gatis.merzvinskis@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("gatis.merzvinskis@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "gatis.merzvinskis@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("anna.denina@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Anna',
        :last_name => 'Denina',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'anna.denina@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "AD",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.legal").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("anna.denina@petpat.lv").individual.party.contacts.where(:contact_value => "anna.denina@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("anna.denina@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "anna.denina@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end

  unless User.find_by_email("janis.berzs@petpat.lv")
    Party.create({
      :identifier => UUIDTools::UUID.random_create.to_s,
      :individual_attributes => {
        :first_name => 'Janis',
        :last_name => 'Berzs',
        :birth_date => Date.today,
        :user_attributes => {
          :email => 'janis.berzs@petpat.lv',
          :password_confirmation => 'password',
          :password => 'password',
          :registration_date => Date.today,
          :initials => "JB",
          :active => false,
          :blocked => false,
          :operating_party_id => Company.find_by_name("party.operating.legal").operating_party.id
        }
      }
    }).individual.user.roles<<Role.all

  end
  unless User.find_by_email("janis.berzs@petpat.lv").individual.party.contacts.where(:contact_value => "janis.berzs@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id).first
    User.find_by_email("janis.berzs@petpat.lv").individual.party.contacts<<Contact.create(:contact_value => "janis.berzs@petpat.lv", :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id)
  end
end