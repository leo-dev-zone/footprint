module AppAccounts
  class AppAccount < ActiveRecord::Base
    attr_accessible :oauth_token, :oauth_token_secret, :oauth_session_handle, :user

    belongs_to :user

    validates :user, presence: true

    def api_key
      APP_CONFIG["#{self.class.name.split('::').last.downcase}_api_key"]
    end

    def api_secret
      APP_CONFIG["#{self.class.name.split('::').last.downcase}_api_secret"]
    end

    def client
      OAuth::Consumer.new(api_key, api_secret, config)
    end
  end
end
