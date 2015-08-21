class User < ActiveRecord::Base
  validates :email, :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}

  after_initialize :ensure_session_token

  has_many :subs,
    dependent: :destroy,
    class_name: "Sub",
    foreign_key: :moderator_id,
    primary_key: :id

  has_many :posts,
    dependent: :destroy,
    class_name: 'Post',
    foreign_key: :author_id,
    primary_key: :id

  has_many :comments,
    dependent: :destroy,
    class_name: "Comment",
    foreign_key: :author_id,
    primary_key: :id

  has_many :votes,
    class_name: "Vote",
    foreign_key: :voter_id

  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.is_password?(password) ? user : nil
  end

  def is_password?(given_password)
    BCrypt::Password.new(password_digest).is_password?(given_password)
  end

  def password=(new_password)
    @password = new_password
    self.password_digest = BCrypt::Password.create(new_password)
  end

  def reset_session_token!
    self.session_token = generate_session_token
    save!
    session_token
  end

  private

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def generate_session_token
    SecureRandom.urlsafe_base64(16)
  end
end
