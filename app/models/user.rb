class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :phone, :numericality => true, :length => { :is => 10 }, :if => "!phone.empty?"
  before_validation :clean_phone
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :phone
  has_many :user_courses
  self.primary_key = :user_id

  def clean_phone
    logger.debug("phone before #{self.phone.class} #{self.phone}")
    self.phone = self.phone.gsub('-', '') if !self.phone.nil?
    logger.debug("phone after #{self.phone.class} #{self.phone}")
  end
end
