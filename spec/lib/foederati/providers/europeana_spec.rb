# frozen_string_literal: true
RSpec.describe Foederati::Providers do
  it 'has registered Europeana' do
    expect(described_class.registry).to have_key(:europeana)
  end
end
