class AddFrozenNowToUsers < ActiveRecord::Migration
  def change
    add_column :users, :frozen_now, :boolean, :default => false
  end
end
