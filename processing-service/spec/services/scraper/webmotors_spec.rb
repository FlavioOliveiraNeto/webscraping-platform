require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Scraper::Webmotors do
  let(:url) do
    'https://www.webmotors.com.br/comprar/honda/civic/20-di-e-hev/4-portas/2024/65420521'
  end

  let(:api_url) do
    'https://www.webmotors.com.br/api/detail/car/honda/civic/20-di-e-hev/4-portas/2024/65420521'
  end

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe '.call' do
    context 'when API returns valid data (200)' do
      let(:api_response) do
        {
          make: 'Honda',
          model: 'Civic',
          pricing: { price: 189900 }
        }.to_json
      end

      before do
        stub_request(:get, api_url)
          .to_return(status: 200, body: api_response, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns brand, model and price from API' do
        result = described_class.call(url)

        expect(result).to eq(
          brand: 'Honda',
          model: 'Civic',
          price: 189900
        )
      end
    end

    context 'when API is blocked (403) and HTML has __NEXT_DATA__' do
      let(:html_response) do
        <<~HTML
          <html>
            <body>
              <script id="__NEXT_DATA__">
                {
                  "props": {
                    "pageProps": {
                      "vehicle": {
                        "Make": "Honda",
                        "Model": "Civic",
                        "Price": "180000"
                      }
                    }
                  }
                }
              </script>
            </body>
          </html>
        HTML
      end

      before do
        stub_request(:get, api_url).to_return(status: 403)

        stub_request(:get, url)
          .to_return(status: 200, body: html_response)
      end

      it 'falls back to HTML scraping successfully' do
        result = described_class.call(url)

        expect(result).to eq(
          brand: 'Honda',
          model: 'Civic',
          price: '180000'
        )
      end
    end

    context 'when API is blocked and HTML does not contain vehicle data' do
      before do
        stub_request(:get, api_url).to_return(status: 403)

        stub_request(:get, url)
          .to_return(status: 200, body: '<html><body>blocked</body></html>')
      end

      it 'raises a controlled scraping error' do
        expect {
          described_class.call(url)
        }.to raise_error(RuntimeError, /Dados do veiculo nao encontrados/)
      end
    end

    context 'when HTTP request fails' do
      before do
        stub_request(:get, api_url).to_timeout
      end

      it 'raises an error' do
        expect {
          described_class.call(url)
        }.to raise_error(StandardError)
      end
    end
  end
end
