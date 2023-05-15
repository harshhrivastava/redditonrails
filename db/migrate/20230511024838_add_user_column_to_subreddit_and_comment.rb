class AddUserColumnToSubredditAndComment < ActiveRecord::Migration[7.0]
  def change
    add_reference :subreddits, :user, null: false
    add_reference :comments, :user, null: false
  end
end
