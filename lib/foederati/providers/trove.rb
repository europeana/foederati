# frozen_string_literal: true

# Trove
Foederati::Providers.register :trove do
  @blank_query = '%20'

  urls.api = 'http://api.trove.nla.gov.au/result?key=%{api_key}&q=%{query}&n=%{limit}&zone=picture&encoding=json'
  urls.site = 'http://trove.nla.gov.au/result?q=%{query}'
  urls.logo = 'http://trove.nla.gov.au/static/51223/img/trove-logo-home-v2.gif'

  results.items = ->(response) { response['response']['zone'] ? response['response']['zone'].detect { |zone| zone['name'] == 'picture' }['records']['work'] : [] }
  results.total = ->(response) { response['response']['zone'] ? response['response']['zone'].detect { |zone| zone['name'] == 'picture' }['records']['total'].to_i : 0 }

  fields.title = 'title'
  fields.thumbnail = ->(item) do
    if item['identifier']
      thumb_identifier = item['identifier'].detect { |identifier| identifier['linktype'] == 'thumbnail' }
      thumb_identifier ? thumb_identifier['value'] : nil
    end
  end
  fields.url = 'troveUrl'
end
