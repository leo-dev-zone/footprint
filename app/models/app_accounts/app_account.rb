module AppAccounts
  class AppAccount < ActiveRecord::Base
    attr_accessible :oauth_token, :oauth_token_secret, :oauth_session_handle

    belongs_to :user

    validates :user, presence: true

    def api_key
      APP_CONFIG["#{self.class.name.split('::').last.downcase}_api_key"]
    end

    def api_secret
      APP_CONFIG["#{self.class.name.split('::').last.downcase}_api_secret"]
    end

    def request_token
      client.get_request_token
    end

    def authorize_url(request_token)
      request_token.authorize_url
    end

    def store_oauth_tokens(request_token, pin)
      tokens = request_token.get_access_token(oauth_verifier: pin).
        params.values_at(:oauth_token, :oauth_token_secret)
      update_attributes!(oauth_token: tokens[0], oauth_token_secret: tokens[1])
    end

    private
      def client
        OAuth::Consumer.new(api_key, api_secret, config)
      end
  end
end
