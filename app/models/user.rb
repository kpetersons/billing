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
  #
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #
  attr_accessor :password
  attr_accessible :email, :password, :password_confirmation, :active, :blocked, :individual_id
  #
  validates :email, :presence => true,
            :format           => {:with => email_regex},
            :uniqueness       => {:case_sensitive => false},
            :length       => {:maximum => 255}
  validates :password, :presence => true,
            :confirmation        => true,
            :length              => {:within => 6..40}
  #
  before_save :encrypt_password
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

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
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
end
