class Subreddit < ApplicationRecord
    has_many :comments, class_name: "Comment", as: :commentable, dependent: :destroy
end
