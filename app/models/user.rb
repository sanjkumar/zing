class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation, :username

  attr_accessor :password
  before_save :encrypt_password

  has_many :posts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
           class_name: "Relationship",
           dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  before_save :create_remember_token

  #validates_confirmation_of :password
  #validates_presence_of :password, :on => :create
  #validates_presence_of :password_confirmation
  #validates_presence_of :email
  #validates_uniqueness_of :email
  #validates_presence_of :username
  #validates_uniqueness_of :username

  validates :username,
            :presence => true,
            :length => {:within => 4..20}


  validates :email,
            :uniqueness => true,
            :length => {:within => 5..40},
            :format => {:with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i}

  validates :password,
            :confirmation => true,
            :length => {:within => 6..20},
            :presence => true

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    Post.from_users_followed_by(self)
  end


  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end


end