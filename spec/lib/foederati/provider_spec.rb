# frozen_string_literal: true
RSpec.describe Foederati::Provider do
  describe '#urls' do
    subject { described_class.new(:new_provider).urls }
    it { is_expected.to respond_to :api }
    it { is_expected.to respond_to :site }
    it { is_expected.to respond_to :logo }
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

  describe '#name' do
    subject { described_class.new(:new_provider) }

    context 'when not set' do
      it 'is derived from ID' do
        expect(subject.name).to eq('New Provider')
      end
    end

    context 'when set' do
      it 'is returned as set' do
        subject.name = 'Nice name'
        expect(subject.name).to eq('Nice name')
      end
    end
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
    let(:search_params) { { query: 'fish' } }

    it 'creates and executes a request' do
      provider = described_class.new(:new_provider)

      mock_request = double(Foederati::Provider::Request)
      mock_response = double(Foederati::Provider::Response)

      allow(provider).to receive(:request).and_return(mock_request)

      expect(mock_request).to receive(:execute).with(search_params).and_return(mock_response)
      expect(mock_response).to receive(:normalise)

      provider.search(search_params)
    end
  end
end
