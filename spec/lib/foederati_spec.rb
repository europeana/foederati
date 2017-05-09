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

  describe '.search' do
    it 'searches the named provider' do
      best_provider = double(Foederati::Provider)
      allow(Foederati::Providers).to receive(:get).with(:best_provider) { best_provider }
      expect(best_provider).to receive(:search).with(query: 'river', api_key: 'secret')
      described_class.search(:best_provider, query: 'river', api_key: 'secret')
    end
  end
end
