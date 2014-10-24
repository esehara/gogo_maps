# GogoMaps

Super simple geocode interface for Ruby, by using awesome GoogleMaps API

## Installation

Install gem as you like.

    $ gem install gogo_maps

or

    $ echo "gem 'gogo_maps'" >> Gemfile

## Demo
```ruby
require 'gogo_maps'

# Address to lat and lng.
GogoMaps.get(address: '長野県上高井郡高山村')
# => { lat: 36.6797676, lng: 138.3632554}

GogoMaps.get(address: '神奈川県横浜市港北区日吉')
# => { lat: 35.5565107, lng: 139.6460026 }

# Lat and lng to Address.
GogoMaps.get(latlng: '35.6506135,139.7539103')
# => '日本, 東京都港区芝１丁目１１−１４'

GogoMaps.get(latlng: '37.358126,-122.050636', language: :en)
# => '902 Rockefeller Drive, Sunnyvale, CA 94087, USA'
```

## Contributing
Please feel free to.
Make you commiter if you wanna be.
