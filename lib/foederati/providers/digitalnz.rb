# frozen_string_literal: true

# DigitalNZ
Foederati::Providers.register :digitalnz do
  urls.api = 'https://api.digitalnz.org/v3/records.json?api_key=%{api_key}&text=%{query}&per_page=%{limit}'
  urls.site = 'https://digitalnz.org/records?text=%{query}'

  results.items = %w(search results)
  results.total = %w(search result_count)

  fields.title = 'title'
  fields.thumbnail = 'thumbnail_url'
  fields.url = 'source_url'
end
