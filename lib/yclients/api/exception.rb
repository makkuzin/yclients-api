module Yclients::Api
  class NoPartnerToken < Exception
    def initialize
      super "Отсутствует partner token"
    end
  end

  class AuthError < Exception; end
end