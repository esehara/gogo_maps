require "gogo_maps/version"
require 'faraday'
require 'json'

module GogoMaps
  class << self
     # @param Hash opts - to support below Ruby1.9x.
    def get_latlng(address, opts={})
      GoogleMapClient.call(
        { address: address, language: :ja, sensor: false }.merge(opts),
        :to_latlng
      )
    end

    # @param Hash opts - to support below Ruby1.9x.
    def get_address(latlng, opts={})
      GoogleMapClient.call(
        { latlng: latlng, language: :ja, sensor: false }.merge(opts),
        :to_address
      )
    end

    def random(opts={})
      lat = ((-180..180).to_a.sample + rand).round(8)
      lng = ((-180..180).to_a.sample + rand).round(8)
      get_address([lat, lng].join(','), opts)
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
        when :to_latlng
          location['geometry']['location'].each_with_object({}) do | (k, v), rslt |
            rslt[k.to_s.to_sym] = v
          end
        when :to_address
          location['formatted_address']
      end
    end
  end

end
