# frozen_string_literal: true
RSpec.describe Foederati::Providers do
  it 'has registered Europeana' do
    expect(described_class.registry).to have_key(:europeana)
  end

  describe 'Europeana provider' do
    let(:provider) { described_class.get(:europeana) }

    describe '#name' do
      subject { provider.name }
      it { is_expected.to eq('Europeana') }
    end
  end
end
