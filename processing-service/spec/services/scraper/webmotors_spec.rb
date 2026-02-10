require 'rails_helper'

RSpec.describe Scraper::Webmotors do
  describe '.call' do
    let(:url) { 'https://www.webmotors.com.br/comprar/honda/civic' }
    
    let(:browser) { instance_double(Ferrum::Browser) }
    let(:network) { double('network') }
    let(:headers) { double('headers') }

    before do
      allow(Ferrum::Browser).to receive(:new).and_return(browser)
      allow(browser).to receive(:headers).and_return(headers)
      allow(headers).to receive(:add)
      allow(browser).to receive(:network).and_return(network)
      allow(network).to receive(:wait_for_idle)
      allow(browser).to receive(:go_to)
      allow(browser).to receive(:quit)
    end

    context 'when page structure is valid' do
      let(:valid_json) do
        {
          props: {
            pageProps: {
              vehicle: {
                Make: 'Honda',
                Model: 'Civic',
                Price: '12000000'
              }
            }
          }
        }.to_json
      end

      before do
        allow(browser).to receive(:evaluate).with(include('__NEXT_DATA__')).and_return(valid_json)
      end

      it 'extracts brand, model and price correctly' do
        result = described_class.call(url)

        expect(result[:brand]).to eq('Honda')
        expect(result[:model]).to eq('Civic')
        expect(result[:price]).to eq('12000000')
      end
    end

    context 'when request fails (simulation of connection error)' do
      before do
        allow(browser).to receive(:go_to).and_raise(StandardError, "Net::ReadTimeout")
      end

      it 'raises an error' do
        expect {
          described_class.call(url)
        }.to raise_error(StandardError, /Net::ReadTimeout/)
      end
    end

    context 'when HTML is missing elements (Blocked or Changed)' do
      before do
        allow(browser).to receive(:evaluate).with(include('__NEXT_DATA__')).and_return(nil)
      end

      it 'raises a specific extraction error' do
        expect {
          described_class.call(url)
        }.to raise_error(RuntimeError, /Elemento __NEXT_DATA__ nao encontrado/)
      end
    end
  end
end