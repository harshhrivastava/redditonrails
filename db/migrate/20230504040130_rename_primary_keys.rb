class RenamePrimaryKeys < ActiveRecord::Migration[7.0]
  def change
    rename_column :comments, :id, :comment_id
    rename_column :subreddits, :id, :subreddit_id
  end
end