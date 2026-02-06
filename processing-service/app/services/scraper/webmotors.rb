require 'ferrum'

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
        timeout: 20
      )

      begin
        browser.go_to(url)

        browser.network.wait_for_idle(duration: 1) 

        json_data = browser.evaluate('document.getElementById("__NEXT_DATA__").textContent')
        
        parsed_data = JSON.parse(json_data)
        vehicle_props = find_vehicle_props(parsed_data)

        {
          brand: vehicle_props['Make'] || vehicle_props['Marca'],
          model: vehicle_props['Model'] || vehicle_props['Modelo'],
          price: vehicle_props['Price'] || vehicle_props['Preco']
        }

      rescue => e
        Rails.logger.error "Ferrum Error: #{e.message}"
        raise e
      ensure
        browser.quit
      end
    end

    def self.find_vehicle_props(data)
      initial_props = data.dig('props', 'pageProps', 'vehicle')
      
      return initial_props if initial_props

      raise "Could not find vehicle data in __NEXT_DATA__"
    end
  end
end