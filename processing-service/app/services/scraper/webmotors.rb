# app/services/scraper/webmotors.rb
require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'

module Scraper
  class Webmotors
    def self.call(url)
      html = fetch_html(url)

      doc = Nokogiri::HTML(html)

      puts("######################################")
      puts(doc)
      puts("######################################")

      script_tag = doc.at_css('script#__NEXT_DATA__')
      raise '__NEXT_DATA__ not found in HTML' unless script_tag

      parsed_data = JSON.parse(script_tag.text)
      vehicle_props = find_vehicle_props(parsed_data)

      {
        brand: vehicle_props['Make'] || vehicle_props['Marca'],
        model: vehicle_props['Model'] || vehicle_props['Modelo'],
        price: vehicle_props['Price'] || vehicle_props['Preco']
      }
    rescue => e
      Rails.logger.error "Nokogiri Scraper Error: #{e.message}"
      raise e
    end

    def self.fetch_html(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      request = Net::HTTP::Get.new(uri.request_uri)
      request['User-Agent'] =
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120 Safari/537.36'

      response = http.request(request)
      response.body
    end

    def self.find_vehicle_props(data)
      initial_props = data.dig('props', 'pageProps', 'vehicle')
      return initial_props if initial_props

      raise 'Could not find vehicle data in __NEXT_DATA__'
    end
  end
end
