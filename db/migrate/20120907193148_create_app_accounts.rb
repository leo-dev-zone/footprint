class CreateAppAccounts < ActiveRecord::Migration
  def change
    create_table :app_accounts do |t|
      t.string :oauth_token
      t.string :oauth_token_secret
      t.integer :user_id
      t.string :oauth_session_handle
      t.string :type

      t.timestamps
    end
  end
end
