class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :bitly_username, :bitly_apikey

  has_many :feeds, dependent: :destroy
  has_many :feed_entries, through: :feeds, dependent: :destroy

  def admin?
    self.role == 'admin'
  end
end
