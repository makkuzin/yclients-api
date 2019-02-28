module Yclients::Api
  class Client
    include Auth
    include Companies

    attr_accessor :partner_token, :user_token, :login, :password

    def initialize(args={})
      @partner_token = args[:partner_token] or raise NoPartnerToken
      @user_token = args[:user_token]
      @login = args[:login]
      @password = args[:password]
    end

    def has_user_token?
      !!@user_token
    end

    def query_param(key, value, type)
      case type
      when :numeric
        if value.respond_to?(:to_i) && value.to_i > 0
          { key => value }
        else
          {}
        end
      when :boolean
        if value == true
          { key => 1 }
        elsif value == false
          { key => 0 }
        else
          {}
        end
      when :string
        if value.kind_of?(String) && value.length > 0
          { key => value }
        else
          {}
        end
      else
        {}
      end
    end

    def headers(args={auth: false})
      if args[:auth]
        {
          'Authorization' => "Bearer #{@partner_token}, User #{@user_token}",
          "Content-Type" => 'application/json'
        }
      else
        {
          'Authorization' => "Bearer #{@partner_token}",
          "Content-Type" => 'application/json'
        }
      end
    end

  end
end
