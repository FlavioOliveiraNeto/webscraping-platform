require 'rails_helper'

RSpec.describe Scraper::Webmotors do
  describe '.call' do
    let(:url) { 'https://www.webmotors.com.br/comprar/honda/civic' }
    let(:html_content) { File.read(Rails.root.join('spec/fixtures/webmotors.html')) }

    before do
      stub_request(:get, url)
        .to_return(status: 200, body: html_content)
    end

    context 'when page structure is valid' do
      it 'extracts brand, model and price correctly' do
        result = described_class.call(url)

        expect(result[:brand]).to eq('Honda')
        expect(result[:model]).to eq('Civic')
        
        expect(result[:price]).to eq('12000000') 
      end
    end

    context 'when request fails (404/500)' do
      before do
        stub_request(:get, url).to_return(status: 404)
      end

      it 'raises an error' do
        expect {
          described_class.call(url)
        }.to raise_error(RuntimeError, /Request failed with status 404/)
      end
    end

    context 'when HTML is missing elements' do
      let(:broken_html) { '<html><body><h1>Nada aqui</h1></body></html>' }

      before do
        stub_request(:get, url).to_return(status: 200, body: broken_html)
      end

      it 'raises a specific extraction error' do
        expect {
          described_class.call(url)
        }.to raise_error(StandardError, /Brand not found in HTML/)
      end
    end
  end
end