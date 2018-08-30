class AddUserIdToScheduler < ActiveRecord::Migration
  def change
    add_column :schedulers, :user_id, :integer
    add_index :schedulers, :user_id
  end
end
