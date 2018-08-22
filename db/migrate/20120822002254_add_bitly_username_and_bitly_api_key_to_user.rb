class AddBitlyUsernameAndBitlyApiKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :bitly_username, :string
    add_column :users, :bitly_apikey, :string
  end
end
