# frozen_string_literal: true

# Trove
Foederati::Providers.register :trove do
  urls.api = 'http://api.trove.nla.gov.au/result?key=%{api_key}&q=%{query}&n=%{limit}&zone=picture&encoding=json'
  urls.site = 'http://trove.nla.gov.au/result?q=%{query}'

  results.items = ->(response) { response['response']['zone'].detect { |zone| zone['name'] == 'picture' }['records']['work'] }
  results.total = ->(response) { response['response']['zone'].detect { |zone| zone['name'] == 'picture' }['records']['total'].to_i }

  fields.title = 'title'
  fields.thumbnail = ->(item) { item['identifier'].detect { |identifier| identifier['linktype'] == 'thumbnail' }['value'] }
  fields.url = 'troveUrl'
end
