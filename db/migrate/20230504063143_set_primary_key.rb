class SetPrimaryKey < ActiveRecord::Migration[7.0]
  def change
    change_column :subreddits, :subreddit_id, :integer, primary_key: true
    change_column :comments, :comment_id, :integer, primary_key: true
  end
end
