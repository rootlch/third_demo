class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy

  before_save { email.downcase! }
  before_create :create_remember_token 

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: { with: VALID_EMAIL_REGEX }

  validates :password, length: { minimum: 6 }
  has_secure_password

  class << self
    def new_remember_token
      SecureRandom.urlsafe_base64
    end 

    def digest(token)
      Digest::SHA1.hexdigest(token.to_s)
    end
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

  private 
  def create_remember_token
    self.remember_token = self.class.digest(self.class.new_remember_token)
  end
end
