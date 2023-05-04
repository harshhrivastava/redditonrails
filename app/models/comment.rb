class Comment < ApplicationRecord
    belongs_to :subreddit, class_name: "Subreddit"
    belongs_to :parent_comment, class_name: "Comment"
    has_many :subcomments, class_name: "Comment", as: :commentable, dependent: :destroy

    def path
        if parent_comment.present?
            [id].unshift(parent_comment.path).flatten
        else
            [id]
        end
    end
end