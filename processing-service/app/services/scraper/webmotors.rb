require 'httparty'
require 'nokogiri'
require 'json'
require 'uri'

module Scraper
  class Webmotors
    BASE_HEADERS = {
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
      "Accept-Language" => "pt-BR,pt;q=0.9",
      "Accept" => "text/html"
    }.freeze

    API_HEADERS = BASE_HEADERS.merge(
      "Accept" => "application/json",
      "Origin" => "https://www.webmotors.com.br",
      "Referer" => "https://www.webmotors.com.br"
    ).freeze
    
    # Fluxo principal
    def self.call(url)
      api_data = fetch_from_api(url)
      return api_data if api_data
      fetch_from_html(url)
    end

    # API /api/detail/car
    def self.fetch_from_api(url)
      api_url = build_api_url(url)

      response = HTTParty.get(api_url, headers: API_HEADERS, timeout: 15)

      if response.code == 403
        Rails.logger.warn("[Webmotors] API bloqueada (403) para #{api_url}")
        return nil
      end

      return nil unless response.success?

      data = JSON.parse(response.body)

      {
        brand: data['make'] || data['brand'],
        model: data['model'],
        price: data.dig('pricing', 'price') || data['price']
      }
    rescue JSON::ParserError, HTTParty::Error => e
      Rails.logger.warn("[Webmotors] Erro ao acessar API: #{e.message}")
      nil
    end

    # HTML + Nokogiri
    def self.fetch_from_html(url)
      response = HTTParty.get(url, headers: BASE_HEADERS, timeout: 20)
      raise "Falha ao acessar a pagina (status #{response.code})" unless response.success?

      html = response.body
      raise "Pagina vazia ou invalida" if html.nil? || html.strip.empty?

      doc = Nokogiri::HTML(html)

      vehicle_data = extract_from_next_data(doc)
      vehicle_data ||= extract_from_html_nodes(doc)

      raise "Dados do veiculo nao encontrados" unless vehicle_data

      vehicle_data
    end

    # Estratégias de extração
    def self.extract_from_next_data(doc)
      script = doc.at_css('#__NEXT_DATA__')
      return nil unless script

      json = JSON.parse(script.text)

      props =
        json.dig('props', 'pageProps', 'vehicle') ||
        json.dig('props', 'pageProps', 'data') ||
        json.dig('props', 'pageProps', 'initialState', 'ad', 'details')

      return nil unless props.is_a?(Hash)

      {
        brand: props['Make'] || props['Marca'] || props.dig('specs', 'make'),
        model: props['Model'] || props['Modelo'] || props.dig('specs', 'model'),
        price: extract_price(props)
      }
    rescue JSON::ParserError
      nil
    end

    def self.extract_from_html_nodes(doc)
      brand =
        doc.at_css('[data-testid="vehicle-brand"]')&.text ||
        doc.at_css('.vehicle-details__brand')&.text

      model =
        doc.at_css('[data-testid="vehicle-model"]')&.text ||
        doc.at_css('.vehicle-details__model')&.text

      price =
        doc.at_css('[data-testid="vehicle-price"]')&.text ||
        doc.at_css('.vehicle-pricing__price')&.text

      return nil unless brand || model || price

      {
        brand: brand&.strip || 'N/A',
        model: model&.strip || 'N/A',
        price: price&.strip || 'N/A'
      }
    end

    # Helpers
    def self.extract_price(props)
      props['Price'] ||
        props['Preco'] ||
        props.dig('pricing', 'priceFormatted') ||
        props.dig('pricing', 'price')
    end

    def self.build_api_url(url)
      uri = URI.parse(url)
      uri.path = uri.path.sub('/comprar', '/api/detail/car')
      uri.to_s
    end

    private_class_method(
      :fetch_from_api,
      :fetch_from_html,
      :extract_from_next_data,
      :extract_from_html_nodes,
      :extract_price,
      :build_api_url
    )
  end
end
