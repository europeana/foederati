# frozen_string_literal: true
RSpec.describe Foederati::Providers do
  it 'has registered DPLA' do
    expect(described_class.registry).to have_key(:dpla)
  end

  describe 'DPLA provider' do
    let(:provider) { described_class.get(:dpla) }

    describe '#name' do
      subject { provider.name }
      it { is_expected.to eq('DPLA') }
    end
  end
end
