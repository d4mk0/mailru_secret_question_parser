class AddCommentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :comment, :string, :limit => 1500
  end
end
