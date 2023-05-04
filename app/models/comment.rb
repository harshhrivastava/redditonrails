class Comment < ApplicationRecord
    belongs_to :subreddit, inverse_of: :comments
    belongs_to :parent_comment, inverse_of: :subcomments
    has_many :subcomments, class_name: "Comment", as: :commentable, dependent: :destroy

    def path
        if parent_comment.present?
            [id].unshift(parent_comment.path).flatten
        else
            [id]
        end
    end
end