module Yclients::Api
  class NoPartnerToken < Exception
    def initialize
      super "Отсутствует partner token"
    end
  end

  class AuthError < Exception; end
  class CompaniesAccessError < Exception; end
  class ServiceCategoriesAccessError < Exception; end
  class ServicesAccessError < Exception; end
end
