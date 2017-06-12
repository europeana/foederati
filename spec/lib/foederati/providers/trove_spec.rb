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

    describe '#default_params' do
      describe '#query' do
        subject { provider.default_params.query }
        it { is_expected.to eq('%20') }
      end
    end
  end
end
