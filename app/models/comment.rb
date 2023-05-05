class Comment < ApplicationRecord
    belongs_to :commentable, polymorphic: true
    has_many :comments, as: :commentable

    def path
        if commentable_type == "Comment"
            parent_comment = Comment.find(commentable_id)
            path_array = [Hash.new(id: id, comment: comment, type: "Comment")]
            path_array.unshift(parent_comment.path).flatten
        else
            path_array = [Hash.new(id: id, comment: comment, type: "Comment")]
            subreddit = Subreddit.find(commentable_id)
            parent_subreddit = [Hash.new(id: subreddit[:id], comment: subreddit[:title], type: "Subreddit")]
            path_array.unshift(parent_subreddit).flatten
        end
    end
end