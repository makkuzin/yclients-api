### Категории услуг
### https://yclients.docs.apiary.io/#reference/3
module Yclients::Api
  module ServiceCategories
    URL1 = 'https://api.yclients.com/api/v1/service_category'
    URL2 = 'https://api.yclients.com/api/v1/service_categories'

    # id (Number, 1234) ID категории услуг (для работы с конкретной категорией)
    # staff_id (Number, 1234) ID сотрудника (для получения категорий, привязанных к сотруднику)
    def service_categories(company_id, args={})
      id = query_param(:id, args[:id], :numeric)[:id] if args.key?(:id)
      uri = URI(id.nil? ? "#{URL2}/#{company_id}" : "#{URL2}/#{company_id}/#{id}")
      params = {}
      params.merge!(query_param(:staff_id, args[:staff_id], :numeric)) if args.key?(:staff_id)
      uri.query = URI.encode_www_form(params)

      req = Net::HTTP::Get.new(uri, headers({ auth: false }))

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      json = JSON.parse(res.body)
      if json.kind_of?(Array)
        json
      else
        raise ServiceCategoriesAccessError, json.to_s
      end
    end

    def service_category(company_id, id)
      uri = URI("#{URL1}/#{company_id}/#{id}")
      req = Net::HTTP::Get.new(uri, headers({ auth: false }))

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      json = JSON.parse(res.body)
      if json.kind_of?(Hash) && json.key?('id')
        json
      else
        raise ServiceCategoriesAccessError, json.to_s
      end
    end

=begin TODO
    def new_service_category(company_id, args={}); end
    def edit_service_category(company_id, id=nil, args={}); end
    def delete_service_category(company_id, id=nil); end
=end
  end
end
