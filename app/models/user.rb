class User < ApplicationRecord

    attr_accessor :password, :password_confirmation
    
    validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

    validates :password, presence: true, confirmation: {confirmation: true, message: "does not match"}

    before_save :encrypt_password

    has_many :subreddits, class_name: "Subreddit", dependent: :destroy

    has_many :comments, class_name: "Comment", through: :subreddits, dependent: :destroy
    
    before_update :update_author_name_in_subreddits

    def update_author_name_in_subreddits
    
        subreddits.update_all(author: fname + " " + lname)
    
    end

    def authenticate(plain_password)

        BCrypt::Password.new(self.password_digest).is_password?(plain_password)

    end

    def encrypt_password

        self.password_digest = BCrypt::Password.create(password)

    end

end
