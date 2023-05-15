class AddAuthorColToSubreddit < ActiveRecord::Migration[7.0]
  def change
    add_column :subreddits, :author, :string, null: false
  end
end
