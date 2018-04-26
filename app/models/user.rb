class User < ApplicationRecord
  attr_accessor :password, :password_confirmation, :old_password,
                :remember_token, :activation_token, :reset_token, 
                :crop_x, :crop_y, :crop_w, :crop_h

  mount_uploader :avatar, AvatarUploader
  after_update :crop_avatar

  before_save { self.email = email.downcase }
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: { message: "用户名不能为空" }, 
    length: { maximum: 50, message: "用户名不能超过50个字符" }
  validates :email, presence: { message: "邮箱名不能为空" }, 
    length: { maximum: 255, message: "邮箱名不能超过255个字符"}, 
    uniqueness: { case_sensitive: false, message: "邮箱名必须唯一" }
  validates :email, format: { with: VALID_EMAIL_REGEX, message: "邮箱名格式不正确" }, 
    unless: proc{ |user| user.email.blank? }
  validates :password, presence: { message: "密码不能为空" }, 
    length: { minimum: 6, message: "密码长度不能少于6位" },
    confirmation: { message: "密码和密码确认不一致" },
    allow_blank: true
  validates :avatar, presence: "头像提交不能为空",
    allow_blank: true

  has_secure_password

  has_many :addresses, -> { where(address_type: Address::AddressType::User).order("id desc") }
  belongs_to :default_address, class_name: :Address, optional: true
  has_many :orders

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end


  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    name_changed?
  end
  
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
