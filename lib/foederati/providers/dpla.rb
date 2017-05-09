# frozen_string_literal: true

# DPLA
Foederati::Providers.register :dpla do
  urls.api = 'https://api.dp.la/v2/items?api_key=%{api_key}&q=%{query}&page_size=%{limit}'
  urls.site = 'https://dp.la/search?q=%{query}'

  results.items = 'docs'
  results.total = 'count'

  fields.title = %w(sourceResource title)
  fields.thumbnail = %w(sourceResource object)
  fields.url = 'isShownAt'
end
