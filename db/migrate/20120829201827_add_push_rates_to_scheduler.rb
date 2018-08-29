class AddPushRatesToScheduler < ActiveRecord::Migration
  def change
    add_column :schedulers, :push_rate_from, :integer
    add_column :schedulers, :push_rate_to, :integer
  end
end
