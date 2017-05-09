# frozen_string_literal: true
RSpec.describe Foederati::Provider do
  describe '#urls' do
    subject { described_class.new(:new_provider).urls }
    it { is_expected.to respond_to :api }
    it { is_expected.to respond_to :site }
  end

  describe '#results' do
    subject { described_class.new(:new_provider).results }
    it { is_expected.to respond_to :items }
    it { is_expected.to respond_to :total }
  end

  describe '#fields' do
    subject { described_class.new(:new_provider).fields }
    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :thumbnail }
    it { is_expected.to respond_to :url }
  end

  describe '#initialize' do
    it 'evaluates a given block' do
      provider = described_class.new(:new_provider) do
        urls.api = 'http://api.example.com/'
      end
      expect(provider.urls.api).to eq('http://api.example.com/')
    end
  end

  describe '#search' do
    let(:api_url) { 'http://api.example.com/' }
    let(:query) { 'fish' }
    let(:api_key) { 'secret' }
    let(:api_params) { { q: query, k: api_key } }

    it 'sends an HTTP GET request to the API' do
      stub_request(:get, api_url).with(query: api_params)

      provider = described_class.new(:new_provider)
      provider.urls.api = "#{api_url}?q=%{query}&k=%{api_key}"
      provider.search(query: query, api_key: api_key)

      expect(a_request(:get, api_url).with(query: api_params)).to have_been_made
    end
  end
end
