# frozen_string_literal: true
require 'faraday'

RSpec.describe Foederati::Provider::Response do
  describe '#normalise' do
    let(:provider) do
      Foederati::Provider.new(:friendly_provider) do
        results.total = 'totalItems'
        results.items = 'searchResults'
        fields.title = 'dcTitle'
        fields.thumbnail = 'edmIsShownBy'
        fields.url = 'guid'
      end
    end

    let(:faraday_response) do
      double(Faraday::Response).tap do |faraday_response|
        allow(faraday_response).to receive(:body).and_return(faraday_response_body)
      end
    end

    let(:faraday_response_body) do
      {
        'totalItems' => 123,
        'searchResults' => [
          {
            'dcTitle' => 'One result',
            'edmIsShownBy' => 'http://www.example.com/one.jpg',
            'guid' => 'http://www.example.com/one.html'
          }
        ]
      }
    end

    subject { described_class.new(provider, faraday_response).normalise }

    it { is_expected.to be_a Hash }

    it 'is keyed by provider ID' do
      expect(subject).to have_key(provider.id)
    end

    describe 'provider ID keyed hash' do
      subject { described_class.new(provider, faraday_response).normalise[provider.id] }

      describe 'total' do
        context 'when in API response' do
          it 'is mapped' do
            expect(subject).to have_key(:total)
            expect(subject[:total]).to eq(faraday_response_body['totalItems'])
          end
        end

        context 'when not in API response' do
          before do
            faraday_response_body.delete('totalItems')
          end

          it 'defaults to 0' do
            expect(subject[:total]).to be_zero
          end
        end
      end

      it { is_expected.to have_key :results }

      describe 'results' do
        subject { described_class.new(provider, faraday_response).normalise[provider.id][:results] }

        it { is_expected.to be_a Array }

        it 'has one element for each result' do
          expect(subject.count).to eq(faraday_response_body['searchResults'].count)
        end

        describe 'each result' do
          subject { described_class.new(provider, faraday_response).normalise[provider.id][:results].first }
          let(:provider_result) { faraday_response_body['searchResults'].first }

          it 'includes title' do
            expect(subject[:title]).to eq(provider_result['dcTitle'])
          end

          it 'includes thumbnail' do
            expect(subject[:thumbnail]).to eq(provider_result['edmIsShownBy'])
          end

          it 'includes URL' do
            expect(subject[:url]).to eq(provider_result['guid'])
          end
        end
      end

      describe 'response traversal' do
        it 'handles arrays of keys' do
          provider.results.items = %w(results search)
          faraday_response_body['results'] = {
            'search' => faraday_response_body.delete('searchResults')
          }
          expect(described_class.new(provider, faraday_response).normalise[provider.id][:results].count).to eq(faraday_response_body['results']['search'].count)
        end

        it 'handles procs' do
          provider.results.items = ->(response) { response['searchResults'] }
          expect(described_class.new(provider, faraday_response).normalise[provider.id][:results].count).to eq(faraday_response_body['searchResults'].count)
        end
      end
    end
  end
end
