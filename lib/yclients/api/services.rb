### Услуги
### https://yclients.docs.apiary.io/#reference/4
module Yclients::Api
  module Services
    URL = 'https://api.yclients.com/api/v1/services'

    # service_id (Number, 1234) ID услуги, если нужно работать с конкретной услугой
    # staff_id (Number, 1234) ID сотрудника. Если нужны услуги, которые оказывает конкретный мастер
    # category_id (Number, 1234) ID категории. Если нужны услуги, из конкретной категории
    def services(company_id, args={})
      service_id = query_param(:service_id, args[:service_id], :numeric)[:service_id] if args.key?(:service_id)
      uri = URI(service_id.nil? ? "#{URL}/#{company_id}" : "#{URL}/#{company_id}/#{service_id}")
      params = {}
      params.merge!(query_param(:staff_id, args[:staff_id], :numeric)) if args.key?(:staff_id)
      params.merge!(query_param(:category_id, args[:category_id], :numeric)) if args.key?(:category_id)
      uri.query = URI.encode_www_form(params)

      req = Net::HTTP::Get.new(uri, headers({ auth: false }))

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      json = JSON.parse(res.body)
      if json.kind_of?(Array)
        json
      else
        raise ServicesAccessError, json.to_s
      end
    end

=begin TODO
    def new_service(company_id); end
    def edit_service(company_id, service_id); end
    def delete_service(company_id, service_id); end
=end
  end
end
