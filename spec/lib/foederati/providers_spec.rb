# frozen_string_literal: true
RSpec.describe Foederati::Providers do
  subject { described_class }

  describe '.registry' do
    subject { described_class.registry }

    it 'has indifferent access' do
      expect(subject).to be_a(HashWithIndifferentAccess)
    end

    it 'supports some providers by default' do
      expect(subject.keys.sort).to eq(%w(europeana dpla digitalnz trove).sort)
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
    it 'adds a provider to the registry' do
      subject.register(:new_provider)
      expect(subject.registry).to have_key(:new_provider)
    end

    it 'accepts a provider instance' do
      provider = Foederati::Provider.new(:new_provider)
      subject.register(provider)
      expect(subject.registry[:new_provider]).to eq(provider)
    end

    it 'accepts a Symbol as ID' do
      subject.register(:fish_provider)
      expect(subject.registry[:fish_provider]).to be_a(Foederati::Provider)
    end

    it 'fails with other arg types' do
      expect { subject.register('fish_provider') }.to raise_error(ArgumentError)
    end

    it 'evaluates a given block' do
      subject.register(:new_provider) do
        urls.api = 'http://api.example.com/'
      end
      expect(subject.get(:new_provider).urls.api).to eq('http://api.example.com/')
    end
  end

  describe '.unregister' do
    let(:provider) { Foederati::Provider.new(:cunning_provider) }

    before do
      Foederati::Providers.register(provider)
    end

    it 'removes the provider from the registry' do
      expect(subject.registry.values).to include(provider)
      subject.unregister(provider.id)
      expect(subject.registry.values).not_to include(provider)
    end
  end
end
