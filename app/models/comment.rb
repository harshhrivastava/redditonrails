class Comment < ApplicationRecord

    belongs_to :commentable, polymorphic: true

    has_many :comments, as: :commentable

    def path

        if commentable_type == "Comment"

            parent_comment = Comment.find(commentable_id)

            object = Comment.find(id)

            [object].unshift(parent_comment.path).flatten

        elsif commentable_type == "Subreddit"

            parent_subreddit = Subreddit.find(commentable_id)

            object = Comment.find(id)

            [object].unshift(parent_subreddit).flatten

        end

    end

    def increment_reply_count(comment_id)
    
        if comment_id

            comment = Comment.find(comment_id)

            comment.replies_count = comment.replies_count + 1

            comment.save

        end

    end

end