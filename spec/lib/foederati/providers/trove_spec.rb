# frozen_string_literal: true
RSpec.describe Foederati::Providers do
  it 'has registered Trove' do
    expect(described_class.registry).to have_key(:trove)
  end

  describe 'Trove provider' do
    let(:provider) { described_class.get(:trove) }

    describe '#name' do
      subject { provider.name }
      it { is_expected.to eq('Trove') }
    end
  end
end
