# frozen_string_literal: true
RSpec.describe Foederati::Provider::Request do
  subject { described_class.new(provider) }

  let(:provider) do
    Foederati::Provider.new(:good_provider).tap do |p|
      p.urls.api = "#{api_url}?q=%{query}&k=%{api_key}&l=%{limit}"
    end
  end
  let(:api_url) { 'http://api.example.com/' }
  let(:query) { 'whale' }
  let(:api_key) { 'moby' }
  let(:result_limit) { 10 }

  before do
    Foederati.api_keys.good_provider = api_key
    Foederati.defaults.limit = result_limit
    Foederati::Providers.register(provider)
  end

  after do
    Foederati::Providers.unregister(provider.id)
  end

  describe '#execute' do
    before do
      stub_request(:get, api_url).with(query: hash_including(q: query)).
        to_return(status: 200,
                  body: '{}',
                  headers: { 'Content-Type' => 'application/json;charset=UTF-8' })
    end

    it "sends a request to the provider's API" do
      subject.execute(query: query)
      expect(a_request(:get, api_url).with(query: hash_including(q: query))).to have_been_made
    end

    it 'returns a response object with Faraday response stored' do
      response = subject.execute(query: query)
      expect(response).to be_a Foederati::Provider::Response
      expect(response.faraday_response).to be_a Faraday::Response
    end
  end

  describe '#default_params' do
    it 'adds limit from Foederati defaults' do
      expect(subject.default_params[:limit]).to eq(result_limit)
    end
    it 'adds API key for provider' do
      expect(subject.default_params[:api_key]).to eq(api_key)
    end
  end

  describe '#api_url' do
    it 'replaces placeholders in API URL with params' do
      expect(subject.api_url(query: query)).to \
        eq("http://api.example.com/?q=#{query}&k=#{api_key}&l=#{result_limit}")
    end

    it 'overrides defaults with args' do
      expect(subject.api_url(query: query, limit: 5)).to \
        eq("http://api.example.com/?q=#{query}&k=#{api_key}&l=5")
    end
  end

  describe '#connection' do
    subject { described_class.new(provider).connection }
    it { is_expected.to be_a Faraday::Connection }
  end
end