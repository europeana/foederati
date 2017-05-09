# frozen_string_literal: true
RSpec.describe Foederati do
  describe '.search' do
    it 'searches the named provider' do
      best_provider = double(Foederati::Provider)
      allow(Foederati::Providers).to receive(:get).with(:best_provider) { best_provider }
      expect(best_provider).to receive(:search).with(query: 'river', api_key: 'secret')
      described_class.search(:best_provider, query: 'river', api_key: 'secret')
    end
  end
end
