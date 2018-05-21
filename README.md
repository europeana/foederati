# Foederati

[![Build Status](https://travis-ci.org/europeana/foederati.svg?branch=develop)](https://travis-ci.org/europeana/foederati) [![Coverage Status](https://coveralls.io/repos/github/europeana/foederati/badge.svg?branch=develop)](https://coveralls.io/github/europeana/foederati?branch=develop) [![security](https://hakiri.io/github/europeana/foederati/develop.svg)](https://hakiri.io/github/europeana/foederati/develop) [![Code Climate](https://codeclimate.com/github/europeana/foederati/badges/gpa.svg)](https://codeclimate.com/github/europeana/foederati)

![Foederati: ](app/assets/images/foederati/logo.png "Foederati")

A Ruby library to search Europeana, the Digital Library of America (DPLA), the Digital Library of Australia - Trove, and the Digital Library of New Zealand - DigitalNZ. The library has been designed to make it easy to add more sources to search within.

## Usage

### With Rails

#### Configure Foederati in an initializer
```ruby
# config/initializers/foederati.rb
Foederati.configure do
  api_keys.dpla = 'dpla_api_key'
  api_keys.digitalnz = 'digitalnz_api_key'
  api_keys.europeana = 'europeana_api_key'
  api_keys.trove = 'trove_api_key'

  defaults.limit = 4
end
```

#### Mount the engine
```ruby
# config/routes.rb
mount Foederati::Engine
```

#### Search

The Rails engine provides a single controller which searches one or more of the
available providers' JSON APIs and returns normalised and simplified search
results.

Routes:
* To search one provider, visit e.g. http://www.example.com/foederati/europeana?q=music
* To search multiple providers, visit e.g. http://www.example.com/foederati?p=dpla,trove&q=music

Parameters:
* `l`: number of results to request from each provider
* `p`: comma-separated list of the providers to search
* `q`: search query, passed as-is to provider APIs (so keep it simple if
  searching more than one!)


### Without Rails

TODO: instruct how to use Foederati outside of Rails.

### Registering custom providers

TODO: instruct how to register custom providers.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'foederati'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install foederati
```

## Contributing
TODO: Contribution directions go here.

## License
Licensed under the EUPL V.1.1.

For full details, see [LICENSE.md](LICENSE.md).
