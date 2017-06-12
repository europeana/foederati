# frozen_string_literal: true

# Trove
Foederati::Providers.register :trove do
  urls.api = 'http://api.trove.nla.gov.au/result?key=%{api_key}&q=%{query}&n=%{limit}&zone=picture&encoding=json'
  urls.site = 'http://trove.nla.gov.au/result?q=%{query}'
  urls.logo = 'http://trove.nla.gov.au/static/51223/img/trove-logo-home-v2.gif'

  default_params.query = '%20'

  results.items = lambda do |response|
    response['response']['zone'] ? response['response']['zone'].detect { |zone| zone['name'] == 'picture' }['records']['work'] : []
  end
  results.total = lambda do |response|
    response['response']['zone'] ? response['response']['zone'].detect { |zone| zone['name'] == 'picture' }['records']['total'].to_i : 0
  end

  fields.title = 'title'
  fields.thumbnail = lambda do |item|
    if item['identifier']
      thumb_identifier = item['identifier'].detect { |identifier| identifier['linktype'] == 'thumbnail' }
      thumb_identifier ? thumb_identifier['value'] : nil
    end
  end
  fields.url = 'troveUrl'
end
