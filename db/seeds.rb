# encoding: utf-8
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

AddressType.transaction do
  address_types = ["BILL_TO", "SHIP_TO", "CONTACT_TO"]
  address_types.each do |address_type_name|
    unless AddressType.find_by_name(address_type_name)
      AddressType.create(:name => address_type_name, :built_in => true)
    end
  end
end

@matter_functions = [
    ["funct.matters.link", true],
    ["funct.create.matter", true],
    ["funct.create.matters.trademark", true],
    ["funct.create.matters.patent", true],
    ["funct.create.matters.legal", true],
    ["funct.create.matters.design", true],
    ["funct.create.matters.custom", true],
    ["funct.create.matters.task", true],
    ["funct.create.matters.trademark_search", true],
    ["funct.create.matters.patent_search", true],
    ["funct.create.matters.domain", true],
    ["funct.matters.status.active", true],
    ["funct.matters.status.pending", true],
    ["funct.matters.status.closed", true],
    ["funct.matters.status.appealed", true],
    ["funct.matters.status.lapsed", true],
    ["funct.matters.task.status.open", true],
    ["funct.matters.task.status.awaiting_response", true],
    ["funct.matters.task.status.done", true],
    ["funct.matters.task.status.canceled", true]
]

@invoice_functions = [
    ["funct.invoices.link", true],
    ["funct.create.invoice", true],
    ["funct.invoice.status.open", true],
    ["funct.invoice.status.approved", true],
    ["funct.invoice.status.issued", true],
    ["funct.invoice.status.canceled", true],
    ["funct.invoice.status.awaiting", true],
    ["funct.invoice.status.paid", true],
    ["funct.invoice.status.override", true]
]

@customer_functions = [
    ["funct.customers.link", true],
    ["funct.create.customer", true],
    ["funct.customer.edit.save", true],
    ["funct.customer.edit.save_as", true]
]

@admin_functions = [
    ["funct.admin.link", true],
    ["funct.create.user", true],
    ["funct.activate.user", true],
    ["funct.block.user", true],
    ["funct.create.role", true],
    ["funct.add.role", true],
    ["funct.add.function", true],
    ["funct.create.message", true],
    ["funct.edit.message", true],
]

@minimal_functions = [
    ["funct.login", true],
    ["funct.dashboard.link", true],
    ["funct.profile.link", true]
]

@roles = ["role.minimal", "role.admin", "role.matters", "role.invoices", "role_customers"]

@role_functions = {
    "role.minimal" => @minimal_functions,
    "role.admin" => @admin_functions,
    "role.matters" => @matter_functions,
    "role.invoices" => @invoice_functions,
    "role_customers" => @customer_functions
}

@functions = Array.new.concat(@minimal_functions)
@functions.concat(@admin_functions)
@functions.concat(@matter_functions)
@functions.concat(@invoice_functions)
@functions.concat(@customer_functions)

Function.transaction do

  @functions.each do |function_name|
    unless Function.find_by_name(function_name[0])
      Function.create(:name => function_name[0], :description => "#{function_name[0]}.descr")
    end
  end
end

Role.transaction do

  @roles.each do |role|
    @r = Role.find_by_name(role)
    if @r.nil?
      @r = Role.create(:name => role, :description => "#{role}.descr")
    end
    @role_functions[role].each do |functions|
      @functions.each do |function|
        if function[1]
          unless @r.functions.exists?(:name => function[0])
            @r.functions<<Function.find_by_name(function[0])
          end
        end
      end
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
#      puts "@result.errors #{@result.errors}"
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
#      puts @party.errors
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

MatterType.transaction do
  matter_types = ["matters.trademark", "matters.patent", "matters.legal", "matters.design", "matters.custom", "matters.patent_search", "matters.trademark_search", "matters.domain"]
  matter_types.each do |matter_type|
    MatterType.create(
        :name => matter_type,
        :description => "#{matter_type}.desc") unless !MatterType.find_by_name(matter_type).nil?
    MatterType.find_by_name(matter_type).update_attribute(:function_id, Function.find_by_name("funct.create.#{matter_type}").id)
  end
end

LegalType.transaction do

  prefix = 'matters.legal.type'
  legal_types = ["opp_attack", "opp_Defend", "deeds", "litigation", "other"]
  legal_types.each do |legal_type|
    LegalType.create(:name => legal_type) unless !LegalType.where(:name => legal_type).first.nil?
  end
end

OperatingPartyMatterType.transaction do
  operating_parties = ["party.operating.administration", "party.operating.trademark", "party.operating.patent", "party.operating.legal"]
  #
  OperatingPartyMatterType.delete_all
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.trademark").id,
      :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.patent").id,
      :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.design").id,
      :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.legal").id,
      :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.custom").id,
      :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.patent_search").id,
      :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.trademark_search").id,
      :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.domain").id,
      :operating_party_id => Company.find_by_name("party.operating.petpat").operating_party.id)
  #
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.trademark").id,
      :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.patent").id,
      :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.design").id,
      :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.legal").id,
      :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.custom").id,
      :operating_party_id => Company.find_by_name("party.operating.administration").operating_party.id)
  #
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.trademark").id,
      :operating_party_id => Company.find_by_name("party.operating.trademark").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.design").id,
      :operating_party_id => Company.find_by_name("party.operating.trademark").operating_party.id)
  #
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.patent").id,
      :operating_party_id => Company.find_by_name("party.operating.patent").operating_party.id)
  #
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.legal").id,
      :operating_party_id => Company.find_by_name("party.operating.legal").operating_party.id)
  OperatingPartyMatterType.create(
      :matter_type_id => MatterType.find_by_name("matters.custom").id,
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

InvoiceStatus.transaction do
  prefix = "invoice.status."
  invoice_statuses = [
      ["open", true],
      ["approved", true],
      ["issued", false],
      ["canceled", false],
      ["awaiting", false],
      ["paid", false]
  ]
  invoice_statuses.each do |name|
    is = InvoiceStatus.find_by_name("#{prefix}#{name[0]}")
    unless is
      InvoiceStatus.create(:editable_state => name[1], :name => "#{prefix}#{name[0]}", :function_id => Function.find_by_name("funct.#{prefix}#{name[0]}").id)
    else
      is.update_attributes({:editable_state => name[1], :name => "#{prefix}#{name[0]}", :function_id => Function.find_by_name("funct.#{prefix}#{name[0]}").id})
    end
  end
end

MatterStatus.transaction do
  prefix = "matters.status."
  matter_statuses = ["active", "pending", "closed", "appealed", "lapsed"]
  matter_statuses.each do |name|
    unless MatterStatus.find_by_name("#{prefix}#{name}")
      MatterStatus.create(:name => "#{prefix}#{name}", :function_id => Function.find_by_name("funct.#{prefix}#{name}").id)
    end
  end
end

MatterTaskStatus.transaction do
  prefix = "matters.task.status."
  matter_task_statuses = ["open", "awaiting_response", "done", "canceled"]
  matter_task_statuses.each do |name|
    unless MatterTaskStatus.find_by_name("#{prefix}#{name}")
      MatterTaskStatus.create(:name => "#{prefix}#{name}", :function_id => Function.find_by_name("funct.#{prefix}#{name}").id)
    end
  end
end

OfficialFeeType.transaction do
  OperatingParty.all.each do |op|
    if OfficialFeeType.where(:name => 'Off. LV', :operating_party_id => op.id).first.nil?
      OfficialFeeType.create(:apply_vat => false, :apply_discount => false, :name => 'Off. LV', :description => 'Official fee in LV. Including NIC.LV', :operating_party_id => op.id)
    else
      OfficialFeeType.where(:name => 'Off. LV', :operating_party_id => op.id).first.update_attributes(:apply_vat => false, :apply_discount => false)
    end
    if OfficialFeeType.where(:name => 'Off. Non-LV', :operating_party_id => op.id).first.nil?
      OfficialFeeType.create(:apply_vat => true, :apply_discount => false, :name => 'Off. Non-LV', :description => 'All official fees outside LV', :operating_party_id => op.id)
    else
      OfficialFeeType.where(:name => 'Off. Non-LV', :operating_party_id => op.id).first.update_attributes(:apply_vat => true, :apply_discount => false)
    end
    if OfficialFeeType.where(:name => 'WIPO, OHIM, EPO', :operating_party_id => op.id).first.nil?
      OfficialFeeType.create(:apply_vat => true, :apply_discount => false, :name => 'WIPO, OHIM, EPO', :description => 'Official fees paid to WIPO, OHIM, EPO', :operating_party_id => op.id)
    else
      OfficialFeeType.where(:name => 'WIPO, OHIM, EPO', :operating_party_id => op.id).first.update_attributes(:apply_vat => true, :apply_discount => false)
    end
    unless OfficialFeeType.where(:name => 'OUTSOURCING', :operating_party_id => op.id).first.nil?
      OfficialFeeType.where(:name => 'OUTSOURCING', :operating_party_id => op.id).first.delete
    end
  end
end

AttorneyFeeType.transaction do

  OperatingParty.where(:id => [Company.find_by_name("party.operating.patent").operating_party.id]).all.each do |op|
    aft = AttorneyFeeType.where(:name => 'P-Application', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "P-Application", :description => "Our fee for patent application, validation", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "P-Application", :description => "Our fee for patent application, validation", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'P-Maintenance', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "P-Maintenance", :description => "Our fee for patent annuities, assignment, etc.", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "P-Maintenance", :description => "Our fee for patent annuities, assignment, etc.", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'P-Search', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "P-Search", :description => "Our fee for patent searches", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "P-Search", :description => "Our fee for patent searches", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'P-Other', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "P-Other", :description => "Other fees regarding patent matters", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "P-Other", :description => "Other fees regarding patent matters", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'D-Application', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "D-Application", :description => "Our fee for design application", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "D-Application", :description => "Our fee for design application", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'D-Maintenance', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "D-Maintenance", :description => "Our fee for design renewal and other maintenance", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "D-Maintenance", :description => "Our fee for design renewal and other maintenance", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'D-Search', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "D-Search", :description => "Our fee for design searches", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "D-Search", :description => "Our fee for design searches", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'D-Other', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "D-Other", :description => "Other fees regarding design matters", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "D-Other", :description => "Other fees regarding design matters", :operating_party_id => op.id)
    end
  end

  OperatingParty.where(:id => [Company.find_by_name("party.operating.legal").operating_party.id, Company.find_by_name("party.operating.trademark").operating_party.id]).all.each do |op|
    aft = AttorneyFeeType.where(:name => 'T-Application', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "T-Application", :description => "Our fee for trademark application, coversation", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "T-Application", :description => "Our fee for trademark application, coversation", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'T-Maintenance', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "T-Maintenance", :description => "Our fee for trademark renewal, assignment, etc.", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "T-Maintenance", :description => "Our fee for trademark renewal, assignment, etc.", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'T-Search', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "T-Search", :description => "Our fee for trademark, company name, unregistered rights searches", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "T-Search", :description => "Our fee for trademark, company name, unregistered rights searches", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'T-Other', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "T-Other", :description => "Other fees regarding trademark matters", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "T-Other", :description => "Other fees regarding trademark matters", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'Legal', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "Legal", :description => "All work regarding, oppositions and other legal matters", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "Legal", :description => "All work regarding, oppositions and other legal matters", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'Domain', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "Domain", :description => "All work regarding domain name matters, except legal services", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "Domain", :description => "All work regarding domain name matters, except legal services", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'Customs', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "Customs", :description => "All work regarding customs, communication, destroying goods, etc.", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "Customs", :description => "All work regarding customs, communication, destroying goods, etc.", :operating_party_id => op.id)
    end
  end


  OperatingParty.all.each do |op|
    aft = AttorneyFeeType.where(:name => 'Translations', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "Translations", :description => "Translations performed by us", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "Translations", :description => "Translations performed by us", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'Postal, banking', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => true, :apply_vat => true, :name => "Postal, banking", :description => "Postal, banking, courier, copying, etc.", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => true, :apply_vat => true, :name => "Postal, banking", :description => "Postal, banking, courier, copying, etc.", :operating_party_id => op.id)
    end
    aft = AttorneyFeeType.where(:name => 'OUTSOURCING', :operating_party_id => op.id).first
    if aft.nil?
      AttorneyFeeType.create(:apply_discount => false, :apply_vat => true, :name => "OUTSOURCING", :description => "All work done by our colleagues, except official fees", :operating_party_id => op.id)
    else
      aft.update_attributes(:apply_discount => false, :apply_vat => true, :name => "OUTSOURCING", :description => "All work done by our colleagues, except official fees", :operating_party_id => op.id)
    end
  end
end

Country.transaction do
  countries = [
      'Afghanistan', 'Albania', 'Algeria', 'American Samoa', 'Andorra', 'Angola', 'Anguilla', 'Antarctica', 'Antigua and Barbuda', 'Arctic Ocean', 'Argentina', 'Armenia', 'Aruba', 'Ashmore and Cartier Islands', 'Atlantic Ocean', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain', 'Baltic Sea', 'Baker Island', 'Bangladesh', 'Barbados', 'Bassas da India', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bermuda', 'Bhutan', 'Bolivia', 'Borneo', 'Bosnia and Herzegovina', 'Botswana', 'Bouvet Island', 'Brazil', 'British Virgin Islands', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burundi', 'Cambodia', 'Cameroon', 'Canada', 'Cape Verde', 'Cayman Islands', 'Central African Republic', 'Chad', 'Chile', 'China', 'Christmas Island', 'Clipperton Island',
      'Cocos Islands', 'Colombia', 'Comoros', 'Cook Islands', 'Coral Sea Islands', 'Costa Rica', 'Cote d' 'Ivoire', 'Croatia', 'Cuba', 'Cyprus', 'Czech Republic', 'Democratic Republic of the Congo', 'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'East Timor', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Ethiopia', 'Europa Island', 'Falkland Islands (Islas Malvinas)', 'Faroe Islands', 'Fiji', 'Finland', 'France', 'French Guiana', 'French Polynesia', 'French Southern and Antarctic Lands', 'Gabon', 'Gambia', 'Gaza Strip', 'Georgia', 'Germany', 'Ghana', 'Gibraltar', 'Glorioso Islands', 'Greece', 'Greenland', 'Grenada', 'Guadeloupe', 'Guam', 'Guatemala', 'Guernsey', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti',
      'Heard Island and McDonald Islands', 'Honduras', 'Hong Kong', 'Howland Island', 'Hungary', 'Iceland', 'India', 'Indian Ocean', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Isle of Man', 'Israel', 'Italy', 'Jamaica', 'Jan Mayen', 'Japan', 'Jarvis Island', 'Jersey', 'Johnston Atoll', 'Jordan', 'Juan de Nova Island', 'Kazakhstan', 'Kenya', 'Kerguelen Archipelago', 'Kingman Reef', 'Kiribati', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Macau', 'Macedonia', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Martinique', 'Mauritania', 'Mauritius', 'Mayotte', 'Mediterranean Sea', 'Mexico', 'Micronesia', 'Midway Islands',
      'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Montserrat', 'Morocco', 'Mozambique',
      'Myanmar', 'Namibia', 'Nauru', 'Navassa Island', 'Nepal', 'Netherlands', 'Netherlands Antilles', 'New Caledonia',
      'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'Niue', 'Norfolk Island', 'North Korea', 'North Sea', 'Northern Mariana Islands',
      'Norway', 'Oman', 'Pacific Ocean', 'Pakistan', 'Palau', 'Palmyra Atoll', 'Panama', 'Papua New Guinea', 'Paracel Islands', 'Paraguay', 'Peru', 'Philippines', 'Pitcairn Islands', 'Poland', 'Portugal',
      'Puerto Rico', 'Qatar', 'Republic of the Congo', 'Reunion', 'Romania', 'Ross Sea', 'Russia', 'Rwanda', 'Saint Helena', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Pierre and Miquelon', 'Saint Vincent and the Grenadines',
      'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Georgia and the South Sandwich Islands', 'South Korea',
      'Southern Ocean', 'Spain', 'Spratly Islands', 'Sri Lanka', 'Sudan', 'Suriname', 'Svalbard', 'Swaziland', 'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan', 'Tanzania', 'Tasman Sea', 'Thailand', 'Togo', 'Tokelau', 'Tonga', 'Trinidad and Tobago',
      'Tromelin Island', 'Tunisia', 'Turkey', 'Turkmenistan', 'Turks and Caicos Islands', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom', 'Uruguay',
      'USA', 'Uzbekistan', 'Vanuatu', 'Venezuela', 'Viet Nam', 'Virgin Islands', 'Wake Island', 'Wallis and Futuna', 'West Bank', 'Western Sahara',
      'Yemen', 'Zambia', 'Zimbabwe'
  ]

  countries.each do |country|
    Country.create(:name => country.capitalize) unless !Country.find_by_name(country.capitalize).nil?
    Country.find_by_name(country.capitalize).update_attribute(:name, country.upcase)
  end
end

Customer.transaction do
  customers = [
      ["Agent", "A. A. Thornton & Co.", "GB232930088", "235 High Holborn", "London WC1V 7LE", "", "UNITED KINGDOM"],
      ["Agent", "Ab Ovo Patents & Trademarks", "NL806653772B01", "", "", "", "NETHERLANDS"],
      ["Agent", "ABG Patentes, S.L.", "ESB83769737", "", "", "", "SPAIN"],
      ["Agent", "Adamed sp. Z.o.o.", "PL5251032201", "Pienkow 149", "05-152 Czosnow k/Warszawy", "", "POLAND"],
      ["Agent", "Addleshaw Goddard LPP", "GB873199680", "", "", "", "UNITED KINGDOM"],
      ["Agent", "Advokatbyran Gulliksson AB", "SE556733531901", "", "", "", "SWEDEN"],
      ["Agent", "Advopatent", "HU28178963", "", "", "", "HUNGARY"],
      ["Agent", "Albihns.Zacco AB", "SE556664848001", "", "", "", "SWEDEN"],
      ["Agent", "Alfred E. Tiefenbacher", "DE118260643", "", "", "", "GERMANY"],
      ["Owner", "ALSTOM", "FR60347951238", "", "", "", "FRANCE"],
      ["Agent", "Amazonen - Werke H. Dreyer GmbH & Co. KG", "DE117583895", "", "", "", "GERMANY"],
      ["Agent", "Andrae Flach Haug", "DE129724138", "Balanstrasse 55", "D-81541 Munich", "", "GERMANY"],
      ["Agent", "Anne Ryan & Co", "IE9511152C", "", "", "", "IRELAND"],
      ["Agent", "Appleyard Lees & Co.", "GB184668420", "", "", "", "UNITED KINGDOM"],
      ["Agent", "Awapatent AB", "SE556082702301", "Bellevuevägen 46", "SE-200 71 Malmö", "", "SWEDEN"],
      ["Owner", "B.A.T. (UK and Export) Limited", "GB239136950", "REGENTS PARK ROAD", "MILLBROOK, SOUTHAMPTON", "SO15 8TL", "UNITED KINGDOM"],
      ["Agent", "BARKER BRETTELL", "GB109498934", "", "", "", "UNITED KINGDOM"],
      ["Agent", "Bauer - Vorberg - Kayser", "DE228669197", "Lindenallee 43", "50968 Cologne", "", "GERMANY"],
      ["Agent", "Benjon OY", "FI10243620", "", "", "", "FINLAND"],
      ["Agent", "Beresford & Co", "GB440429471", "16 High Holborn", "London WC1V 6BX", "", "UNITED KINGDOM"],
      ["Agent", "Bergenstrahle & Lindvall AB", "SE556206431001", "", "", "", "SWEDEN"],
      ["Agent", "Berggren OY AB", "FI01070027", "", "", "", "FINLAND"],
      ["Agent", "Bianchetti Bracco Minoja SRL", "IT03202130153", "", "", "", "ITALY"],
      ["Agent", "Biesse S.r.l.", "IT02207610987", "", "", "", "ITALY"],
      ["Owner", "BIGBANK AS", "EE100041383", "", "", "", "ESTONIA"],
      ["Agent", "Bird & Bird LLP", "DE815021337", "Carl-Theodor-Strasse 6", "40213 Dusseldorf", "", "GERMANY"],
      ["Owner", "BMW AG", "DE129273398", "", "", "", "GERMANY"],
      ["Agent", "Bockermann Ksoll Griepenstroh", "DE124146411", "", "", "", "GERMANY"],
      ["Agent", "Boehmert & Boehmert", "DE114522685", "", "", "", "GERMANY"],
      ["Agent", "Borenius & Kemppinen Ltd", "FI10370590", "", "", "", "FINLAND"],
      ["Agent", "Brann AB", "SE556483621001", "", "", "", "SWEDEN"],
      ["Agent", "BRISTOWS", "GB243204894", "", "", "", "UNITED KINGDOM"],
      ["Agent", "Bryan Cave LLP", "DE256518622", "Hamburg", "", "", "GERMANY"],
      ["Agent", "BUDDE SCHOU A/S", "DK21477737", "", "", "", "DENMARK"],
      ["Agent", "Bugnion S.p.A.", "IT00850400151", "Largo Michele Novaro, 1/A", "43100 Parma", "", "ITALY"],
      ["Agent", "Bureau Callewaert", "BE0426925506", "Brusselsesteenweg 108", "B-3090 Overijse", "", "BELGIUM"],
      ["Agent", "Bureau Casalonga & Josse", "FR83315228619", "", "", "", "FRANCE"],
      ["Agent", "Cabinet Beau de Lomenie", "FR21775671076", "", "", "", "FRANCE"],
      ["Agent", "Cabinet Lhermet La Bigne  & Remy", "FR72425105236", "11 boulevard de Sebastopol", "75001 Paris", "", "FRANCE"],
      ["Agent", "Cabinet Malemont", "FR47542010533", "", "", "", "FRANCE"],
      ["Agent", "Cabinet Regimbeau", "FR14784661357", "", "", "", "FRANCE"],
      ["Agent", "Carpmaels & Ransford", "GB232162209", "43-45 Bloomsbury Square", "London WC1A 2RA", "", "UNITED KINGDOM"],
      ["Agent", "CEGUMARK AB", "SE556222960801", "Box 53047", "SE - 400 14 Göteborg", "", "SWEDEN"],
      ["Agent", "Chas Hude A/S", "DK12938179", "", "", "", "DENMARK"],
      ["Owner", "Chivas Brothers LTD", "GB743052164", "", "", "", "UNITED KINGDOM"],
      ["Agent", "Chrystian PRZYBYLSKI, kancelaria patentowa", "PL7251021747", "", "", "", "POLAND"],
      ["Agent", "Compagnie Financiere Alcatel-Lucent", "FR15351213624", "54, rue La Boetie", "75008 Paris", "", "FRANCE"],
      ["Agent", "Compu-Mark NV", "BE0422317610", "", "", "", "BELGIUM"],
      ["Agent", "CONIMAR AB", "SE556306118201", "Stationsvagen 29", "S-141 02 Huddinge", "", "SWEDEN"],
      ["Agent", "Cornelia Stoppkotte", "DE185430025", "", "", "", "GERMANY"],
      ["Agent", "Creative Brands C.V.", "NL812585379B01", "", "", "", "NETHERLANDS"],
      ["Agent", "CURELL SUNOL SLP", "ESB08503963", "", "", "", "SPAIN"],
      ["Agent", "Čermak Horejs Myslil a spol", "CZ27109500", "", "", "", "CZECH REPUBLIC"],
      ["Agent", "Červenka, Kleintova, Turkova", "CZ5553070094", "", "", "", "CZECH REPUBLIC"],
      ["Agent", "D Young & Co", "GB984896339", "", "", "", "UNITED KINGDOM"],
      ["Owner", "DAIICHI Sankyo Europe GmbH", "DE129405556", "Zielstattstrasse 48", "81379 Munich", "", "GERMANY"],
      ["Agent", "Dipl. Phys. Dr. H.H. Stoffregen", "DE112837411", "", "", "", "GERMANY"],
      ["Agent", "DLA Piper Weiss-Tessbach Rechtsanwalte GmbH", "ATU57354589", "Schottenring 14", "1010 Vienna", "", "AUSTRIA"],
      ["Agent", "Dr. Helen Papaconstantinou & Co.", "EL022265707", "2 Coumbari str., Kolonaki", "10674 Athens", "", "GREECE"],
      ["Agent", "Dr. Klaus Beckord", "DE200686107", "Markplatz 17", "D-83607 Holzkirchen", "", "GERMANY"],
      ["Owner", "Dr. Muller Pharma s.r.o.", "CZ63218976", "", "", "", "CZECH REPUBLIC"],
      ["Agent", "DRM Dr. Reinhold Martin", "DE129917987", "Junkerstrasse 3", "82178 Puchheim, Munchen", "", "GERMANY"],
      ["Agent", "Dummett Copp LLP", "GB368397889", "", "", "", "UNITED KINGDOM"],
      ["Agent", "EHRNER & DELMAR Patentbyra AB", "SE556058066301", "Box 10316", "S-100 55 Stockholm", "", "SWEDEN"],
      ["Agent", "Eisenfuhr, Speiser & Partner", "DE114392795", "", "", "", "GERMANY"],
      ["Owner", "Electrolux Rothenburg GmbH", "DE815198157", "Bodelschwinghstrasse 1", "91541 Rothenburg o.d.T.", "", "GERMANY"],
      ["Agent", "F&M Law Firm & IP Consulting", "IT03129280362", "Via dei Lovoleti, 9", "41100 Modena", "", "ITALY"],
      ["Agent", "Field Fisher Waterhouse LLP", "GB232273784", "35 Vine Street", "London EC3N2AA", "", "UNITED KINGDOM"],
      ["Agent", "Forrester & Boehmert", "DE114441475", "", "", "", "GERMANY"],
      ["Agent", "Frese Patent Patentanwälte", "DE270776726", "", "", "", "GERMANY"],
      ["Agent", "Fresenius Kabi Deutschland GmbH", "DE812738852", "", "", "", "GERMANY"],
      ["Agent", "Fumero - Studio Consuelenza Brevetti snc", "IT01903800157", "", "", "", "ITALY"],
      ["Agent", "Galantos Pharma GmbH", "DE244925716", "Freiligrathstr. 12", "55131 Mainz", "", "GERMANY"],
      ["Owner", "Gardena Manufactirung GmbH", "DE811134311", "", "", "", "GERMANY"],
      ["Agent", "GEDEON RICHTER LTD", "HU10484878", "", "", "", "HUNGARY"],
      ["Agent", "Gesthuysen, von Rohr & Eggert", "DE119808947", "Huyssenallee 100", "45128 Essen", "", "GERMANY"],
      ["Agent", "Gevers Marks NV", "BE0455352939", "Frankrijklei 53/55 bus 5", "B-2000 Antwerpen", "", "BELGIUM"],
      ["Agent", "Giambrocono & C.S.p.A.", "IT01698140157", "Via R. Pilo 19/b", "20129 Milano", "", "ITALY"],
      ["Agent", "Glawe Delfs Moll patent und rechtsanwalte", "DE118319199", "P.O. Box. 26 01 62", "D-80058 Munchen", "", "GERMANY"],
      ["Agent", "Golsen Limited", "CY10247962A", "", "", "", "CYPRUS"],
      ["Agent", "Gonzalez-Bueno & Illescas", "ESB84584671", "", "", "", "SPAIN"],
      ["Agent", "Groth & Co.", "SE916642393001", "Box 6107", "SE-102 32 STOCKHOLM", "", "SWEDEN"],
      ["Agent", "Grunecker, Kinkelldey, Stockmair", "DE130494157", "", "", "", "GERMANY"],
      ["Agent", "Guess Europe Sagl", "IT05847610960", "", "", "", "ITALY"],
      ["Agent", "Hansen, Patentanwaltskanzlei", "DE812862848", "", "", "", "GERMANY"],
      ["Agent", "Hansmann & Vogeser", "DE130497585", "", "", "", "GERMANY"],
      ["Agent", "Heinanen AB", "FI02135902", "", "", "", "FINLAND"],
      ["Agent", "Heinonen & Co", "FI11092107", "", "", "", "FINLAND"],
      ["Agent", "HEISEL - Gewerblicher Rechtsschutz", "DE184379448", "Zeppelinstrasse 2", "78464 Konstanz", "", "GERMANY"],
      ["Agent", "HH Partners OY", "FI16365215", "Mannerheimintie 14 A, P.O. Box 232", "FIN-00101 Helsinki", "", "FINLAND"],
      ["Agent", "Hirsch & Associes", "FR73422810572", "58, Avenue Marceau", "75008, Paris", "", "FRANCE"],
      ["Agent", "Hogan Lovells International LLP", "DE812922576", "", "", "", "GERMANY"],
      ["Agent", "Hunter-Fleming Limited", "GB736928004", "REGUS HOUSE 1 FRIARY", "TEMPLE QUAY BRISTOL", "BS1 6EA", "UNITED KINGDOM"],
      ["Agent", "IP Consulting Ltd.", "BG130947757", "", "", "", "BULGARIA"],
      ["Owner", "IPSEN Pharma S.A.S.", "FR80308197185", "", "", "", "FRANCE"],
      ["Owner", "ISEA S.r.l.", "IT01417910435", "Via G. Carducci, 6", "62012 Civitanova Marche (MC)", "", "ITALY"],
      ["Agent", "J. Pereira da  Cruz, S.A.", "PT500563454", "Rua Victor Cordon 14", "1249-103 Lisboa", "", "PORTUGAL"],
      ["Agent", "Jacobacci & Partners", "IT00501050017", "", "", "", "ITALY"],
      ["Agent", "Jeck Fleck Herrmann", "DE194490987", "", "", "", "GERMANY"],
      ["Agent", "K.O.B. N.V.", "BE0450490071", "", "", "", "BELGIUM"],
      ["Agent", "Kaminski Sobdaja & Partners", "PL5213408331", "", "", "", "POLAND"],
      ["Agent", "Käosaar & Co OÜ", "EE100019975", "", "", "", "ESTONIA"],
      ["Agent", "KIRKPATRIK SA", "BE0426603921", "Avenue Wolfers 32", "BE-1310 La Hulpe", "", "BELGIUM"],
      ["Agent", "Klinger & Kollegen", "DE152953464", "", "", "", "GERMANY"],
      ["Agent", "Kohler Schmid Mobus", "DE147520119", "", "", "", "GERMANY"],
      ["Agent", "KOITEL Patent & Trademark", "EE100083367", "", "", "", "ESTONIA"],
      ["Agent", "Kolster OY AB", "FI01101292", "", "", "", "FINLAND"],
      ["Agent", "KRKA, D.D", "SI82646716", "", "", "", "SLOVENIA"],
      ["Agent", "KROHER STROBEL", "DE176881241", "Bavariaring 20", "D-80336 Munchen", "", "GERMANY"],
      ["Agent", "Kuhnen & Wacker", "DE813496485", "", "", "", "GERMANY"],
      ["Agent", "LC Services bvba", "BE0888633826", "", "", "", "BELGIUM"],
      ["Agent", "Leine, Wagner, Dr. Herrguth", "DE115700252", "", "", "", "GERMANY"],
      ["Agent", "Leonhard Olgemoller Fricke", "DE161873896", "", "", "", "GERMANY"],
      ["Agent", "Lippert, Stachow, Schmidt & Partner", "DE814431496", "", "", "", "GERMANY"],
      ["Owner", "L'OREAL", "FR10632012100", "", "", "", "FRANCE"],
      ["Agent", "Lorenz & Kollegen", "DE258038276", "", "", "", "GERMANY"],
      ["Agent", "Lovells (Alicante) Limited & Cia", "ESC53510046", "", "", "", "SPAIN"],
      ["Agent", "Macquet & Associes", "FR57477487268", "", "", "", "FRANCE"],
      ["Agent", "Maiwald Patentanwalts GmbH", "DE175858893", "", "", "", "GERMANY"],
      ["Agent", "Mamo TCV Advocates", "MT15861920", "90, Palazzo Pietro Stiges", "Triq id- Dejqa", "VLT 1436, Valletta ", "MALTA"],
      ["Agent", "Mark - Iventa Co Ltd", "SI75729687", "", "", "", "SLOVENIA"],
      ["Owner", "Mars Chocolate UK Limited", "GB927310243", "", "", "", "UNITED KINGDOM"],
      ["Owner", "Martel & CO", "FR67342438892", "", "", "", "FRANCE"],
      ["Owner", "MAVIC S.A.S.", "FR09515155844", "", "", "", "FRANCE"],
      ["Agent", "MCR Ricerche", "IT13143070152", "", "", "", "ITALY"],
      ["Agent", "Merkenbureau Knijff & Partners BV", "NL007033199B01", "P.O. Box 5054", "1380 GB WEESP", "", "NETHERLANDS"],
      ["Owner", "Merz GmbH & Co. KGaA", "DE813402129", "Eckenheimer Landstrasse 100", "D-60318 Frankfurt / Main", "", "GERMANY"],
      ["Agent", "METIDA Law firm of Reda Žaboliene", "LT100002043411", "", "", "", "LITHUANIA"],
      ["Agent", "Mewburn Ellis LLP", "GB233114903", "33 Gutter Lane", "London EC2V 8AS", "", "UNITED KINGDOM"],
      ["Agent", "Mintz, Levin, Cohn, Ferris, Glovsky, Popeo IP, LLP", "GB835930316", "", "", "", "UNITED KINGDOM"],
      ["Agent", "Moderna Forsakringar Sak AB c/o MAQS Law Firm", "SE556559709201", "", "", "", "SWEDEN"],
      ["Agent", "Murgitroyd & Company", "GB262384359", "Corinthian House", "17 Lansdowne Road, Croydon", "London, CR0 2BX", "UNITED KINGDOM"],
      ["Owner", "Navayo Research KFT", "HU13233420", "Nagykatai ut 9", "H-5100, Jaszbereny", "", "HUNGARY"],
      ["Agent", "Novagraaf Belgium SA", "BE0446258101", "", "", "", "BELGIUM"],
      ["Owner", "Nycomed GmbH", "DE811113447", "", "", "", "GERMANY"],
      ["Agent", "Office Freylinger", "LU17560609", "", "", "", "LUXEMBOURG"],
      ["Agent", "Oficina Ponti", "ESB08492688", "", "", "", "SPAIN"],
      ["Agent", "Olswang", "GB945639582", "90 High Holborn", "London WC1V 6XX", "DX 37972 KINGSWAY", "UNITED KINGDOM"],
      ["Agent", "Ostriga, Sonnet, Wirths & Roche", "DE121068676", "", "", "", "GERMANY"],
      ["Agent", "OY Jalo Ant-Wuorinen", "FI18994103", "", "", "", "FINLAND"],
      ["Agent", "Patendiburoo KOPPEL OU", "EE100924772", "Kajaka 4-10", "11317 Tallin", "", "ESTONIA"],
      ["Agent", "Patent & Trademark agency Marie Smrčkova", "CZ436128423", "", "", "", "CZECH REPUBLIC"],
      ["Agent", "Patentanwalt Dipl.-ing. Wolfgang Cichy", "DE812674103", "", "", "", "GERMANY"],
      ["Agent", "Patentiniu Paslaugu Centras, UAB", "LT219562610", "", "", "", "LITHUANIA"],
      ["Agent", "Patentna Pisarna, d.o.o.", "SI21402469", "", "", "", "SLOVENIA"],
      ["Agent", "PATRADE A/S", "DK30546865", "Fredens Torv 3A", "DK-8000 Aarhus C", "", "DENMARK"],
      ["Agent", "Peek & Cloppenburg KG", "DE121287018", "", "", "", "GERMANY"],
      ["Agent", "Perani Mezzanotte & Partners", "IT13427880151", "Plazza San Babila 5", "20122 Milano", "", "ITALY"],
      ["Agent", "Perfetti van Melle S.p.A", "IT04219660158", "Via XXV Aprile 7", "Lainate 20020", "", "ITALY"],
      ["Owner", "PharmIdea Eesti OU", "EE101333427", "1/3 Estonia Pst.", "Tallin, 10143", "", "ESTONIA"],
      ["Agent", "Philips & Leigh", "GB232702496", "", "", "", "UNITED KINGDOM"],
      ["Agent", "PHS General Design Services B.V.", "NL812104389B01", "PO Box 12222", "Amsterdam 1100 AE", "", "NETHERLANDS"],
      ["Agent", "PMR Avocats", "FR02487660060", "153 boulevar Haussmann", "75008 Paris", "", "FRANCE"],
      ["Agent", "Polmos Bialystok S.A.", "PL5420201558", "", "", "", "POLAND"],
      ["Owner", "POLPHARMA SA", "PL5920202822", "", "", "", "POLAND"],
      ["Agent", "Polypatent - Fleischer,Godemeyer,Kierdorf & Co", "DE812910055", "", "", "", "GERMANY"],
      ["Agent", "Potter Clarkson LLP", "GB116634579", "Park View House", "58 The Ropewalk, Nottingham NG1 5DD", "", "UNITED KINGDOM"],
      ["Owner", "Pro Natura GmbH", "DE171685760", "Jahnstrasse 49", "601318 Frankfurt am Main", "", "GERMANY"],
      ["Agent", "Prungneu - Schaub", "FR45405396573", "", "", "", "FRANCE"],
      ["Agent", "Rapisardi IP limited", "GB877204507", "2A, Collier House,", "163-169 Brompton Road", "SW3 1PY London", "UNITED KINGDOM"],
      ["Owner", "Ratiopharm GmbH", "DE812425448", "Graf-Arco-Str.3", "D-89079 Ulm", "", "GERMANY"],
      ["Agent", "Rautaruukki Oyj", "FI01132769", "", "", "", "FINLAND"],
      ["Agent", "Reinhard, Skuhra, Weise & Partner GbR", "DE130254464", "", "", "", "GERMANY"],
      ["Agent", "RGC Jenkins & Co.", "GB232117508", "", "", "", "UNITED KINGDOM"],
      ["Agent", "RIELDA S.r.l. c/o PATRITO  BREVETTI", "IT00765560578", "", "", "", "ITALY"],
      ["Agent", "RIERA", "ESB79992145", "", "", "", "SPAIN"],
      ["Agent", "RM Hirvela Patent Bureau Ltd", "EE100448164", "", "", "", "ESTONIA"],
      ["Owner", "RoC International", "LU12308700", "", "", "", "LUXEMBOURG"],
      ["Agent", "Rott, Ruzicka & Guttmann", "CZ5701010568", "", "", "", "CZECH REPUBLIC"],
      ["Agent", "ROUSE & CO INTERNATIONAL", "GB549118431", "11th floor, Exchange Tower", "1 Harbour Exchange Square,", "London, E14 9GE", "UNITED KINGDOM"],
      ["Agent", "Ruff, Wilhelm, Beier, Dauster & Partner", "DE813083851", "Kronenstraße 30", "D-70174 Stuttgart", "", "GERMANY"],
      ["Agent", "S.B.G.&K. Patent and Law Offices", "HU28070157", "P.O. Box 360", "1369 Budapest", "", "HUNGARY"],
      ["Agent", "Salomon S.A.S.", "FR55325820751", "", "", "", "FRANCE"],
      ["Agent", "Schoppe, Zimmermann, Stockeler & Zinkler", "DE130575439", "Postfach 246", "82043 Pullach bei Munchen", "", "GERMANY"],
      ["Owner", "Schwarz Pharma AG", "DE121395506", "", "", "", "GERMANY"],
      ["Agent", "Serjeants", "GB339408345", "25 The Crescent, King Street,", "Leicester, LE1 6RX", "", "UNITED KINGDOM"],
      ["Agent", "Setterwalls Advokatbyra", "SE556624378701", "Box 4501, SE-203 20", "Malmo", "", "SWEDEN"],
      ["Agent", "Sodema Conseils S.A.", "FR24388574147", "", "", "", "FRANCE"],
      ["Agent", "Solf & Zapf", "DE121110206", "Schlossbleiche 20", " 42103 Wuppertal", "", "GERMANY"],
      ["Agent", "SOLVAY A.S.", "BE0403091220", "", "", "", "BELGIUM"],
      ["Agent", "Stevens Hewlett & Perkins", "GB232844665", "", "", "", "UNITED KINGDOM"],
      ["Agent", "Stora Enso AB", "SE556173336001", "", "", "", "SWEDEN"],
      ["Agent", "Strom & Gulliksson", "SE556102270701", "P.O. Box 4188", "S-203 13 Malmo", "", "SWEDEN"],
      ["Agent", "Studio Bonini srl", "IT01792420240", "", "", "", "ITALY"],
      ["Agent", "Studio Torta", "IT06589950010", "", "", "", "ITALY"],
      ["Owner", "Škoda Auto", "CZ00177041", "", "", "", "CZECH REPUBLIC"],
      ["Agent", "Taylow Wessing", "GB524096748", "5 New str, sq.", "London EC4 A 3TW", "", "UNITED KINGDOM"],
      ["Owner", "Teva Czech Industries, s.r.o.", "CZ26785323", "", "", "", "CZECH REPUBLIC"],
      ["Agent", "Tomkins & Co.", "IE9F51078S", "", "", "", "IRELAND"],
      ["Agent", "Uexull & Stolberg", "DE118166268", "", "", "", "GERMANY"],
      ["Agent", "USTERVALL", "EE100022205", "", "", "", "ESTONIA"],
      ["Agent", "Valdorfo Didmenos UAB", "LT249370416", "V.Sirokomles g. 36", "Nemezio gyv., Vilniaus raj., LT-13260", "", "LITHUANIA"],
      ["Agent", "VEREENIGDE", "NL002877168B01", "", "", "", "NETHERLANDS"],
      ["Owner", "VION N.V.", "NL001665455B01", "", "", "", "NETHERLANDS"],
      ["Agent", "Wallach, Koch, Dr. Haibach, Feldkamp", "DE129991350", "Garmischer Str. 4,", "80339, Munchen", "", "GERMANY"],
      ["Agent", "Weickmann & Weickmann", "DE130753315", "", "", "", "GERMANY"],
      ["Agent", "Wilson Gunn | Patent and Trademark Attorneys", "GB306164289", "5th Floor, Blackfriars House", "The Parsonage, Manchester M3 2JA", "", "UNITED KINGDOM"],
      ["Agent", "Withers & Rogers LLP", "GB849768160", "", "", "", "UNITED KINGDOM"],
      ["Agent", "Witte, Weller und Partner Patentanwalte", "DE147641313", "", "", "", "GERMANY"],
      ["Agent", "Worldwide Brands, Inc.", "DE122787403", "", "", "", "GERMANY"],
      ["Owner", "YVES SAINT LAURENT", "FR76429057276", "7, avenue George V", "F-75008 Paris", "", "FRANCE"],
      ["Agent", "Zacco Denmark A/S", "DK21624683", "Hans-Bekkevolds Alle 7", "DK-2900 Hellerup", "", "DENMARK"],
      ["Agent", "Zacco Netherlands BV", "NL009402627B01", "", "", "", "NETHERLANDS"],
      ["Agent", "ZBM Patents, S.L.", "ESB63357735", "Pl. Catalunya, 1", "08002 Barcelona", "", "SPAIN"]
  ]
  customers.each do |company|
    @result = Party.new({
                            :identifier => UUIDTools::UUID.random_create.to_s,
                            :party_type => 'party company customer',
                            :company_attributes => {
                                :name => company[1],
                                :registration_number => company[2]
                            },
                            :customer_attributes => {
                                :customer_type => company[0],
                                :vat_registration_number => company[2],
                            }
                        })
    if @result.save
      unless !Address.where(:party_id => @result.company.party_id, :address_type_id => AddressType.find_by_name('BILL_TO').id, :country_id => Country.find_by_name(company[6].upcase).id, :city => company[3], :street => company[4], :house_number => company[5]).first.nil?
        @address = Address.new(:party_id => @result.company.party_id, :address_type_id => AddressType.find_by_name('BILL_TO').id, :country_id => Country.find_by_name(company[6].upcase).id, :city => company[3], :street => company[4], :house_number => company[5])
        @address.save
      end
    end
  end
end

DefaultFilter.transaction do
  DefaultFilter.delete_all
  DefaultFilterColumn.delete_all
  UserFilter.delete_all
  UserFilterColumn.delete_all

  matter_columns = [
      {:column_query => 'registration_number', :column_position => 1, :is_default => true, :column_name => 'mi_registration_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'description', :column_position => 2, :is_default => false, :column_name => 'mi_description', :column_type => 'col-text', :translate => false},
      {:column_query => 'created_at', :column_position => 3, :is_default => true, :column_name => 'mi_created_at', :column_type => 'col-date', :translate => false},
      {:column_query => 'updated_at', :column_position => 4, :is_default => true, :column_name => 'mi_updated_at', :column_type => 'col-date', :translate => false},
      {:column_query => 'notes', :column_position => 5, :is_default => false, :column_name => 'mi_notes', :column_type => 'col-text', :translate => false},
      {:column_query => 'applicant', :column_position => 6, :is_default => false, :column_name => 'mi_applicant', :column_type => 'col-text', :translate => false},
      {:column_query => 'agent', :column_position => 7, :is_default => true, :column_name => 'mi_agent', :column_type => 'col-text', :translate => false},
      {:column_query => 'author', :column_position => 8, :is_default => false, :column_name => 'mi_author', :column_type => 'col-text', :translate => false},
      {:column_query => 'operating_party', :column_position => 9, :is_default => false, :column_name => 'mi_operating_party', :column_type => 'col-text', :translate => true},
      {:column_query => 'matter_type', :column_position => 10, :is_default => true, :column_name => 'mi_matter_type', :column_type => 'col-text', :translate => true},
      {:column_query => 'matter_status', :column_position => 11, :is_default => true, :column_name => 'mi_matter_status', :column_type => 'col-text', :translate => true},
      {:column_query => 'application_number', :column_position => 12, :is_default => false, :column_name => 'mi_application_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'application_date', :column_position => 13, :is_default => false, :column_name => 'mi_application_date', :column_type => 'col-date', :translate => false},
      {:column_query => 'date_of_order', :column_position => 14, :is_default => false, :column_name => 'mi_date_of_order', :column_type => 'col-date', :translate => false},
      {:column_query => 'wipo_number', :column_position => 15, :is_default => false, :column_name => 'mi_wipo_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'priority_date', :column_position => 16, :is_default => false, :column_name => 'mi_priority_date', :column_type => 'col-date', :translate => false},
      {:column_query => 'mark_name', :column_position => 17, :is_default => false, :column_name => 'mi_mark_name', :column_type => 'col-text', :translate => false},
      {:column_query => 'ctm_number', :column_position => 18, :is_default => false, :column_name => 'mi_ctm_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'cfe_index', :column_position => 19, :is_default => false, :column_name => 'mi_cfe_index', :column_type => 'col-text', :translate => false},
      {:column_query => 'patent_number', :column_position => 20, :is_default => false, :column_name => 'mi_patent_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'patent_grant_date', :column_position => 21, :is_default => false, :column_name => 'mi_patent_grant_date', :column_type => 'col-date', :translate => false},
      {:column_query => 'ep_appl_number', :column_position => 22, :is_default => false, :column_name => 'mi_ep_appl_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'ep_number', :column_position => 23, :is_default => false, :column_name => 'mi_ep_number', :column_type => 'col-number', :translate => false},
      {:column_query => 'design_number', :column_position => 24, :is_default => false, :column_name => 'mi_design_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'rdc_appl_number', :column_position => 25, :is_default => false, :column_name => 'mi_rdc_appl_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'rdc_number', :column_position => 26, :is_default => false, :column_name => 'mi_rdc_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'opposed_marks', :column_position => 27, :is_default => false, :column_name => 'mi_opposed_marks', :column_type => 'col-text', :translate => false},
      {:column_query => 'instance', :column_position => 28, :is_default => false, :column_name => 'mi_instance', :column_type => 'col-text', :translate => false},
      {:column_query => 'date_of_closure', :column_position => 29, :is_default => false, :column_name => 'mi_date_of_closure', :column_type => 'col-date', :translate => false},
      {:column_query => 'opposite_party', :column_position => 30, :is_default => false, :column_name => 'mi_opposite_party', :column_type => 'col-text', :translate => false},
      {:column_query => 'opposite_party_agent', :column_position => 31, :is_default => false, :column_name => 'mi_opposite_party_agent', :column_type => 'col-text', :translate => false},
      {:column_query => 'legal_type', :column_position => 32, :is_default => false, :column_name => 'mi_legal_type', :column_type => 'col-text', :translate => true},
      {:column_query => 'date_of_order_alert', :column_position => 33, :is_default => false, :column_name => 'mi_date_of_order_alert', :column_type => 'col-date', :translate => false},
      {:column_query => 'ca_application_date', :column_position => 34, :is_default => false, :column_name => 'mi_ca_application_date', :column_type => 'col-date', :translate => false},
      {:column_query => 'ca_application_number', :column_position => 35, :is_default => false, :column_name => 'mi_ca_application_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'client_all_ip', :column_position => 36, :is_default => false, :column_name => 'mi_client_all_ip', :column_type => 'col-text', :translate => false},
      {:column_query => 'patent_eq_numbers', :column_position => 37, :is_default => false, :column_name => 'mi_patent_eq_numbers', :column_type => 'col-text', :translate => false},
      {:column_query => 'no_of_patents', :column_position => 38, :is_default => false, :column_name => 'mi_no_of_patents', :column_type => 'col-number', :translate => false},
      {:column_query => 'search_for', :column_position => 39, :is_default => false, :column_name => 'mi_search_for', :column_type => 'col-text', :translate => false},
      {:column_query => 'no_of_objects', :column_position => 40, :is_default => false, :column_name => 'mi_no_of_objects', :column_type => 'col-number', :translate => false},
      {:column_query => 'express_search', :column_position => 41, :is_default => false, :column_name => 'mi_express_search', :column_type => 'col-boolean', :translate => false},
      {:column_query => 'domain_name', :column_position => 42, :is_default => false, :column_name => 'mi_domain_name', :column_type => 'col-text', :translate => false},
      {:column_query => 'registration_date', :column_position => 43, :is_default => false, :column_name => 'mi_registration_date', :column_type => 'col-date', :translate => false}
  ]

  dashboard_columns = matter_columns

  invoice_columns = [
      {:column_query => 'registration_number', :column_position => 0, :is_default => true, :column_name => 'ii_registration_number', :column_type => 'col-text', :translate => false},
      {:column_query => 'customer_name', :column_position => 1, :is_default => true, :column_name => 'ii_customer_name', :column_type => 'col-text', :translate => false},
      {:column_query => 'person', :column_position => 2, :is_default => false, :column_name => 'ii_person', :column_type => 'col-text', :translate => false},
      {:column_query => 'address', :column_position => 3, :is_default => false, :column_name => 'ii_address', :column_type => 'col-text', :translate => false},
      {:column_query => 'currency', :column_position => 4, :is_default => false, :column_name => 'ii_currency', :column_type => 'col-text', :translate => false},
      {:column_query => 'author', :column_position => 5, :is_default => false, :column_name => 'ii_author', :column_type => 'col-text', :translate => false},
      {:column_query => 'status', :column_position => 6, :is_default => true, :column_name => 'ii_status', :column_type => 'col-text', :translate => true},
      {:column_query => 'our_ref', :column_position => 7, :is_default => true, :column_name => 'ii_our_ref', :column_type => 'col-text', :translate => false},
      {:column_query => 'your_ref', :column_position => 8, :is_default => true, :column_name => 'ii_your_ref', :column_type => 'col-text', :translate => false},
      {:column_query => 'your_date', :column_position => 9, :is_default => false, :column_name => 'ii_your_date', :column_type => 'col-date', :translate => false},
      {:column_query => 'invoice_date', :column_position => 10, :is_default => false, :column_name => 'ii_invoice_date', :column_type => 'col-date', :translate => false},
      {:column_query => 'payment_term', :column_position => 11, :is_default => false, :column_name => 'ii_payment_term', :column_type => 'col-number', :translate => false},
      {:column_query => 'discount', :column_position => 12, :is_default => false, :column_name => 'ii_discount', :column_type => 'col-number', :translate => false},
      {:column_query => 'po_billing', :column_position => 13, :is_default => false, :column_name => 'ii_po_billing', :column_type => 'col-text', :translate => false},
      {:column_query => 'subject', :column_position => 14, :is_default => false, :column_name => 'ii_subject', :column_type => 'col-text', :translate => false},
      {:column_query => 'ending_details', :column_position => 15, :is_default => false, :column_name => 'ii_ending_details', :column_type => 'col-text', :translate => false},
      {:column_query => 'created_at', :column_position => 16, :is_default => false, :column_name => 'ii_created_at', :column_type => 'col-date', :translate => false},
      {:column_query => 'updated_at', :column_position => 17, :is_default => false, :column_name => 'ii_updated_at', :column_type => 'col-date', :translate => false},
      {:column_query => 'rate', :column_position => 18, :is_default => false, :column_name => 'ii_rate', :column_type => 'col-number', :translate => false},
      {:column_query => 'apply_vat', :column_position => 19, :is_default => false, :column_name => 'ii_apply_vat', :column_type => 'col-boolean', :translate => false},
      {:column_query => 'date_paid', :column_position => 20, :is_default => false, :column_name => 'ii_date_paid', :column_type => 'col-date', :translate => false},
      #{:column_query => 'total_official_fee', :column_position => 21, :is_default => false, :column_name => 'ii_total_official_fee', :column_type => 'col-number', :translate => false},
      #{:column_query => 'total_attorney_fee', :column_position => 22, :is_default => false, :column_name => 'ii_total_attorney_fee', :column_type => 'col-number', :translate => false},
      #{:column_query => 'subtotal', :column_position => 23, :is_default => false, :column_name => 'ii_subtotal', :column_type => 'col-number', :translate => false},
      {:column_query => 'total_vat', :column_position => 22, :is_default => true, :column_name => 'ii_total_vat', :column_type => 'col-number', :translate => false},
      {:column_query => 'grand_total', :column_position => 23, :is_default => true, :column_name => 'ii_grand_total', :column_type => 'col-number', :translate => false}
  ]

  tables = [
      "invoices",
      "matters",
      "dashboard",
      "customers"
  ]

  columns = {
      "matters" => matter_columns,
      "dashboard" => dashboard_columns,
      "customers" => [],
      "invoices" => invoice_columns
  }

  tables.each do |table|
    default_filter = DefaultFilter.new(:table_name => table)
    if !default_filter.save()
      default_filter = DefaultFilter.find_by_table_name(table)
    end
    DefaultFilterColumn.transaction do
      columns[table].each do |column|
        filter_column = DefaultFilterColumn.new(column.merge(:default_filter_id => default_filter.id))
        unless filter_column.save
          puts "filter_column.errors: #{filter_column.errors}"
        end
      end
    end
  end
end

MatterTaskType.transaction do
  matter_task_types = [
      {:name => 'TRAN', :description => 'Translation'},
      {:name => 'RENW', :description => 'Renewal, annuitie'},
      {:name => 'OPP', :description => 'Opposition'},
      {:name => 'PREG', :description => 'Publication, registration'},
      {:name => 'OOFF', :description => 'Other official'},
      {:name => 'CREQ', :description => 'Client requested'},
      {:name => 'CUST', :description => 'Customs'},
      {:name => 'MISC', :description => 'Miscellaneous'}
  ]
  matter_task_types.each do |matter_task_type|
    type = MatterTaskType.new(matter_task_type)
    unless MatterTaskType.find_by_name(matter_task_type[:name])
      unless type.save
        puts "matter_task_type errors #{type.errors}"
      end
    end
  end
end

Party.transaction do
  Party.all.each do |p|
    effective_date = DateTime.now
    p.update_attribute(:version, 1)
    #p.update_attribute(:orig_id, p.id)
    p.update_attribute(:date_effective, effective_date)
    Company.where(:party_id => p.id).all.each do |c|
      c.update_attribute(:version, 1)
      #c.update_attribute(:orig_id, c.id)
      c.update_attribute(:date_effective, effective_date)
    end
    Customer.where(:party_id => p.id).all.each do |c|
      c.update_attribute(:version, 1)
      #c.update_attribute(:orig_id, c.id)
      c.update_attribute(:date_effective, effective_date)
    end

    Address.where(:party_id => p.id).all.each do |a|
      a.update_attribute(:version, 1)
      #a.update_attribute(:orig_id, a.id)
      a.update_attribute(:date_effective, effective_date)
    end
  end
end

User.transaction do
  User.all.each do |x|
    x.update_attribute(:active, true)
  end
end