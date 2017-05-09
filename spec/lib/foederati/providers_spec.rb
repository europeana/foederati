# frozen_string_literal: true
RSpec.describe Foederati::Providers do
  describe '.registry' do
    it 'supports some providers by default' do
      expect(described_class.registry.keys.sort).to eq(%i(europeana dpla digitalnz trove).sort)
    end
  end

  describe '.get' do
    let(:registered_provider) { double(Foederati::Provider) }
    it 'returns the registered provider' do
      allow(described_class).to receive(:registry) { { registered_provider: registered_provider } }
      expect(described_class.get(:registered_provider)).to eq(registered_provider)
    end
  end

  describe '.register' do
    subject { described_class }

    it 'adds a provider to the registry' do
      subject.register(:new_provider)
      expect(subject.registry).to have_key(:new_provider)
    end

    it 'evaluates a given block' do
      subject.register(:new_provider) do
        urls.api = 'http://api.example.com/'
      end
      expect(subject.get(:new_provider).urls.api).to eq('http://api.example.com/')
    end
  end
end
