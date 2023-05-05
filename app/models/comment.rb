class Comment < ApplicationRecord
    belongs_to :commentable, polymorphic: true
    has_many :comments, as: :commentable

    def path
        # comment = Comment.find(id)
        # if comment[:commentable_type] == "Comment"
        #     parent_comment = Comment.find(comment[:commentable_id])
        #     path_array = [Hash.new(id: comment[:id], comment: comment[:comment], type: "Comment")]
        #     path_array.unshift(parent_comment.path).flatten
        # else
        #     path_array = [Hash.new(id: comment[:id], comment: comment[:comment], type: "Comment")]
        #     subreddit = Subreddit.find(comment[:commentable_id])
        #     parent_subreddit = [Hash.new(id: subreddit[:id], subreddit: subreddit[:title], type: "Subreddit")]
        #     path_array.unshift(parent_subreddit).flatten
        # end

        if commentable_type == "Comment"
            parent_comment = Comment.find(commentable_id)
            [id].unshift(parent_comment.path).flatten
        elsif commentable_type == "Subreddit"
            parent_subreddit = Subreddit.find(commentable_id)
            [id].unshift(parent_subreddit[:id]).flatten
        end
    end
end