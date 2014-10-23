require "gogo_maps/version"
require 'faraday'
require 'json'

module GogoMaps
  class << self
     # @param Hash opts - to support below Ruby1.9x.
    def get(opts={})
      fail 'Should provide either address or latlng' unless opts[:address] || opts[:latlng]

      GoogleMapClient.call(
        { language: :ja, sensor: false }.merge(opts),
        opts[:address] ? :to_latlng : :to_address
      )
    end

    def random(opts={})
      lat = ((-180..180).to_a.sample + rand).round(8)
      lng = ((-180..180).to_a.sample + rand).round(8)
      get({latlng:[lat, lng].join(',')}.merge(opts))
    rescue
      random #FIXIT:
    end
  end

  class GoogleMapClient
    ENDPOINT = 'http://maps.googleapis.com'
    @@_conn ||= Faraday.new(url: ENDPOINT) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end

    def self.call(params, sym)
      response = @@_conn.get do |req|
        req.url '/maps/api/geocode/json'
        req.params = params
      end

      unless location = JSON.parse(response.body)['results'][0]
        fail 'Something wrong with Google API or your params'
      end

      case sym
        when :to_latlng  then location['geometry']['location']
        when :to_address then location['formatted_address']
      end
    end
  end

end
