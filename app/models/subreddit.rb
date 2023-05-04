class Subreddit < ApplicationRecord
    has_many :comments, as: :commentable, dependent: :destroy
end
