class Subreddit < ApplicationRecord

    has_many :comments, as: :commentable, dependent: :destroy

    def increment_reply_count(subreddit_id)
    
        if subreddit_id

            subreddit = Subreddit.find(subreddit_id)

            subreddit.replies_count = subreddit.replies_count + 1

            subreddit.save

        end

    end
    
end