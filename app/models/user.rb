class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :phone, :numericality => true, :length => { :is => 10 }, :if => "!phone.nil?"
  before_validation :clean_phone
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :phone
  has_many :user_courses
  self.primary_key = :user_id

  def clean_phone
    # TODO figure out why self.phone works, but phone doesn't
    if self.phone.blank?
      self.phone = nil
    else
      self.phone = self.phone.gsub('-', '')
    end
  end
end
