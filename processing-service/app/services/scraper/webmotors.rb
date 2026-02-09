require 'ferrum'
require 'json'

module Scraper
  class Webmotors
    def self.call(url)
      browser = Ferrum::Browser.new(
        browser_path: '/usr/bin/chromium',
        browser_options: {
          'no-sandbox': nil,
          'disable-gpu': nil,
          'disable-dev-shm-usage': nil
        },
        headless: true,
        timeout: 30
      )

      begin
        browser.go_to(url)
        browser.network.wait_for_idle(duration: 2)

        json_text = browser.evaluate('document.getElementById("__NEXT_DATA__")?.textContent')
        raise "Elemento __NEXT_DATA__ nao encontrado na pagina" unless json_text

        parsed_data = JSON.parse(json_text)
        vehicle_props = find_vehicle_props(parsed_data)

        {
          brand: vehicle_props['Make'] || vehicle_props['Marca'] || 'N/A',
          model: vehicle_props['Model'] || vehicle_props['Modelo'] || 'N/A',
          price: extract_price(vehicle_props)
        }
      ensure
        browser.quit
      end
    end

    def self.find_vehicle_props(data)
      vehicle = data.dig('props', 'pageProps', 'vehicle')
      return vehicle if vehicle

      ad_data = data.dig('props', 'pageProps', 'data')
      return ad_data if ad_data

      raise "Dados do veiculo nao encontrados no JSON da pagina"
    end

    def self.extract_price(props)
      price = props['Price'] || props['Preco'] || props['Prices']

      if price.is_a?(Hash)
        price['Price'] || price['SearchPrice'] || price.values.first.to_s
      else
        price.to_s.presence || 'N/A'
      end
    end

    private_class_method :find_vehicle_props, :extract_price
  end
end
