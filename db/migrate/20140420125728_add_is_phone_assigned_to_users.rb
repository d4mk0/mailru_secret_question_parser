class AddIsPhoneAssignedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_phone_assigned, :boolean, default: false
    add_column :users, :response_status, :integer
    
    add_index :users, :is_phone_assigned
    add_index :users, :response_status
  end
end
