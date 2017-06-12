# frozen_string_literal: true
RSpec.describe Foederati::Providers do
  it 'has registered DigitalNZ' do
    expect(described_class.registry).to have_key(:digitalnz)
  end

  describe 'DigitalNZ provider' do
    let(:provider) { described_class.get(:digitalnz) }

    describe '#name' do
      subject { provider.name }
      it { is_expected.to eq('DigitalNZ') }
    end
  end
end
