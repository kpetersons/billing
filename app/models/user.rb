# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  individual_id      :integer(4)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  active             :boolean(1)
#  blocked            :boolean(1)
#  registration_date  :date
#  activation_key     :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  operating_party_id :integer(4)
#  initials           :string(255)
#

# == Schema Information
# Schema version: 20110609074500
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  individual_id      :integer(4)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  active             :boolean(1)
#  blocked            :boolean(1)
#  registration_date  :date
#  activation_key     :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#
class User < ActiveRecord::Base   
  
  belongs_to :individual
  has_many :user_roles
  has_many :roles, :through => :user_roles
  has_many :matters, :foreign_key => :author_id
  has_many :matter_tasks, :foreign_key => :author_id
  has_many :invoices, :foreign_key => :author_id
  has_many :invoice_lines, :foreign_key => :author_id
  has_many :invoice_line_presets, :foreign_key => :author_id
  #  
  belongs_to :operating_party
  #
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #
  attr_accessor :password
  attr_protected :password_current
  attr_accessible :email, :password, :password_confirmation, :active, :blocked, :individual_id, :registration_date, :activation_key, :operating_party_id, :initials
  #
  validates :email, :presence => true,
            :format           => {:with => email_regex},
            :uniqueness       => {:case_sensitive => false},
            :length       => {:maximum => 255}
  validates :password, :presence => true,
            :confirmation        => true,
            :length              => {:within => 6..40}, :if => Proc.new{ |user| user.active == true }
  validates :operating_party_id, :presence => true
  validates :initials, :presence => true
  #
  before_save :encrypt_password
  before_create :generate_activation_key
  #
  def has_password?(submitted_password)  
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)    
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def has_function name
    !User.where(:id => self.id).joins(:roles => [:functions]).where(:functions => {:name => name[:name]}).first.nil?
  end
  
  def activate
    self.active = !active 
    return true
  end
  
  def block 
    self.block = !block 
    return true
  end
  
  def matter_types
    operating_party.matter_types unless operating_party.matter_types.nil?
  end    
  
  def password_current
    @password_current
  end
  
  def password_current= value
    @password_current = value
  end  

  private

  def encrypt_password
    unless password.nil?
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end  

  def generate_activation_key     
    self.activation_key = UUIDTools::UUID.random_create.to_s    
  end
  
end
