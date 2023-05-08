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

    def comments_before_comment(main_comment)

        before_time = main_comment.created_at

        commentable_id = main_comment.commentable_id

        id = main_comment.id

        before_comments = Comment.where("(created_at < ? or created_at = ?) and commentable_id = ? and id <> ?", before_time, before_time, commentable_id, id)[0..9]

    end

    def comments_after_comment(main_comment)

        after_time = main_comment.created_at

        commentable_id = main_comment.commentable_id

        id = main_comment.id

        before_comments = Comment.where("(created_at > ? or created_at = ?) and commentable_id = ? and id <> ?", after_time, after_time, commentable_id, id)[0..9]
        
    end

end