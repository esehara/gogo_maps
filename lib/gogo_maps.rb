require "gogo_maps/version"
require 'faraday'
require 'json'

module GogoMaps
  class << self
    def get_latlng(address, opts={})
      GoogleMapClient.call(
        { address: address, language: :ja, sensor: false }.merge(opts),
        :to_latlng
      )
    end

    def get_address(lat, lng, opts={})
      GoogleMapClient.call(
        { latlng: "#{lat},#{lng}", language: :ja, sensor: false }.merge(opts),
        :to_address
      )
    end

    def random(opts={}, limit=20)
      lat,lng  = (0..1).map{ ((-180..180).to_a.sample + rand).round(8) }
      get_address(lat, lng, opts)
    rescue => e
      if limit < 1
        raise e
      else
        random(opts, limit - 1)
      end
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
      json_response = JSON.parse(response.body)

      unless location = json_response['results'][0]
        error_message =
          if json_response['status'] && json_response['error_message']
            "Google API returns error message:: #{json_response['status']}: #{json_response['error_message']}"
          else
            'Something wrong with Google API or your params'              
          end
        fail error_message
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
