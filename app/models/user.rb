class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :bitly_username, :bitly_apikey

  validates :email, presence: true
  validates :email, :uniqueness => true
  validates :role, :inclusion => { :in => %w(user admin) }

  has_many :feeds, dependent: :destroy
  has_many :feed_entries, through: :feeds, dependent: :destroy
  has_one :scheduler
  has_one :twitter, dependent: :destroy, class_name: 'AppAccounts::Twitter'
  has_one :linkedin, dependent: :destroy, class_name: 'AppAccounts::Linkedin'
  has_one :facebook, dependent: :destroy, class_name: 'AppAccounts::Facebook'

  def admin?
    self.role == 'admin'
  end
end
