# frozen_string_literal: true

# Europeana
Foederati::Providers.register :europeana do
  urls.api = 'https://www.europeana.eu/api/v2/search.json?wskey=%{api_key}&query=%{query}&rows=%{limit}&profile=minimal'
  urls.site = 'http://www.europeana.eu/portal/search?q=%{query}'

  results.items = 'items'
  results.total = 'totalResults'

  fields.title = 'title'
  fields.thumbnail = 'edmPreview'
  fields.url = 'guid'
end
