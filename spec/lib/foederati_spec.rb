# frozen_string_literal: true
RSpec.describe Foederati do
  describe '.defaults' do
    subject { described_class.defaults }
    it { is_expected.to respond_to :limit }
  end

  describe '.api_keys' do
    subject { described_class.api_keys }
    it 'accepts arbitrary attr assignment' do
      expect { subject.not_a_known_api }.not_to raise_error
    end
  end

  describe '.configure' do
    it 'configures Foederati in a block' do
      Foederati::Providers.register(:my_provider)
      described_class.configure do
        api_keys.my_provider = 'secret'
      end
      expect(described_class.api_keys.my_provider).to eq('secret')
    end
  end

  describe '.connection' do
    subject { described_class.connection }
    it { is_expected.to be_a Faraday::Connection }
  end

  describe '.search' do
    context 'with one provider specified' do
      it 'searches that provider' do
        best_provider = double(Foederati::Provider)
        allow(Foederati::Providers).to receive(:get).with(:best_provider) { best_provider }
        expect(best_provider).to receive(:search).with(query: 'river', api_key: 'secret')
        described_class.search(:best_provider, query: 'river', api_key: 'secret')
      end
    end

    context 'with multiple providers specified' do
      let(:first_provider) { double(Foederati::Provider) }
      let(:second_provider) { double(Foederati::Provider) }
      let(:params) { { query: 'jelly' } }

      before do
        allow(Foederati::Providers).to receive(:get).with(:first_provider) { first_provider }
        allow(Foederati::Providers).to receive(:get).with(:second_provider) { second_provider }
        allow(first_provider).to receive(:search) { { first_provider: {} } }
        allow(second_provider).to receive(:search) { { second_provider: {} } }
      end

      it 'searches each of those providers' do
        expect(first_provider).to receive(:search).with(params)
        expect(second_provider).to receive(:search).with(params)
        described_class.search(:first_provider, :second_provider, params)
      end

      it 'merges results' do
        response = described_class.search(:first_provider, :second_provider, params)
        expect(response).to have_key(:first_provider)
        expect(response).to have_key(:second_provider)
      end
    end
  end
end
