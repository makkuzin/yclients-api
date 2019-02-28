### Авторизация
### https://yclients.docs.apiary.io/#reference/0
module Yclients::Api
  module Auth
    URL = 'https://api.yclients.com/api/v1/auth'

    def auth
      @user_token || auth!
    end

    def auth!
      unless @login || @password
        raise AuthError, "Отсутствует логин или пароль"
      end

      uri = URI(URL)
      req = Net::HTTP::Post.new(uri, headers)

      req.body = { "login" => @login, "password" => @password }.to_json

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
      json = JSON.parse(res.body)

      if json.key?('user_token')
        @user_token = json['user_token']
      else
        raise AuthError, json.to_s
      end
    end
  end
end
