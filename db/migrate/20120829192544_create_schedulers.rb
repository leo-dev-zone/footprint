class CreateSchedulers < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.string :days_of_week
      t.datetime :push_at_from
      t.datetime :push_at_to

      t.timestamps
    end
  end
end
