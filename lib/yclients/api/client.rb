module Yclients::Api
  class Client
    attr_accessor :partner_token, :user_token, :login, :password
    include Urls

    def initialize(args={})
      @partner_token = args[:partner_token] or raise NoPartnerToken
      @user_token = args[:user_token]
      @login = args[:login]
      @password = args[:password]
    end

    def has_user_token?
      !!user_token
    end

    def auth
      return user_token unless user_token.nil?
      auth!
    end

    def auth!
      unless login || password
        raise AuthError, "Отсутствует логин или пароль"
      end

      uri = URI(AUTH_URL)
      req = Net::HTTP::Post.new(uri, {
        'Authorization' => "Bearer #{partner_token}",
        "Content-Type" => 'application/json'
      })

      req.body = { "login" => login, "password" => password }.to_json

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
      json = JSON.parse(res.body)

      if json.key?('user_token')
        @user_token = json['user_token']
      else
        raise AuthError, json.to_s
      end
      user_token
    end

  end
end
