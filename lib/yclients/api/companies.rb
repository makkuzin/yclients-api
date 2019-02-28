### Компании
### https://yclients.docs.apiary.io/#reference/2
module Yclients::Api
  module Companies
    URL1 = 'https://api.yclients.com/api/v1/company' 
    URL2 = 'https://api.yclients.com/api/v1/companies'

    # group_id (Number, 83): ID сети компаний. Фильтр по идентификатору сети компаний Default: 83
    # my (Number, 1): Только для авторизованного пользователя. Если нужно компании, на управление которыми пользователь имеет права
    # active (Number, 1): Если нужно получить только активные для онлайн-записи компании
    # moderated (Number, 1): Если нужно получить только прошедшие модерацию компании. Т.е. чей контент проверен для публикации
    # for_booking (Number, 1): Если нужно получить поле next_slot по каждой компании
    # show_groups (Number, 1): Включить в обьект компании список сетей в которые входит эта компания
    # title: Поиск по вхождению подстроки в название компании
    # distance: Радиус поиска
    # coordinate_lat: Широта центра поиска по координатам
    # coordinate_lon: Долгота центра поиска по координатам
    def companies(args={})
      uri = URI(URL2)
      params = {}
      params.merge!(query_param(:group_id, args[:group_id], :numeric)) if args.key?(:group_id)
      params.merge!(query_param(:my, args[:my], :boolean)) if args.key?(:my)
      params.merge!(query_param(:active, args[:active], :boolean)) if args.key?(:active)
      params.merge!(query_param(:moderated, args[:moderated], :boolean)) if args.key?(:moderated)
      params.merge!(query_param(:forBooking, args[:for_booking], :boolean)) if args.key?(:for_booking)
      params.merge!(query_param(:show_groups, args[:show_groups], :boolean)) if args.key?(:show_groups)
      params.merge!(query_param(:title, args[:title], :string)) if args.key?(:title)
#     params.merge!(query_param(:distance, args[:distance], :string)) if args.key?(:distance)
#     params.merge!(query_param(:coordinate_lat, args[:coordinate_lat], :string)) if args.key?(:coordinate_lat)
#     params.merge!(query_param(:coordinate_lon, args[:coordinate_lon], :string)) if args.key?(:coordinate_lon)
      uri.query = URI.encode_www_form(params)

      req = Net::HTTP::Get.new(uri, {
        'Authorization' => "Bearer #{@partner_token}",
        "Content-Type" => 'application/json'
      })
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      json = JSON.parse(res.body)
      if json.kind_of?(Array)
        json
      else
        raise AuthError, json.to_s
      end
    end

  end
end
