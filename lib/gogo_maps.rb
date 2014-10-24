require "gogo_maps/version"
require 'faraday'
require 'json'

module GogoMaps
  class InvalidRandomMapError < StandardError; end
  
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

    def random(opts={})
      lat,lng  = (0..1).map{ ((-180..180).to_a.sample + rand).round(8) }
      get_address(lat, lng, opts)
    rescue
      random #FIXIT:
    end

    def _random_by(min_lat, max_lat, min_lng, max_lng, opts, times=0)
      begin
        lat = ((min_lat..max_lat).to_a.sample + rand).round(8)
        lng = ((min_lng..max_lng).to_a.sample + rand).round(8)
        if times > 20
          get_address(lat, lng, opts)
        end
      rescue
        _random_by(min_lat, max_lng, min_lng, max_lng, opts, times + 1)
      end
      raise InvalidRandomMapError, "Invalid Random Map Error." 
    end
    private :_random_by
    
    def random_by(min_lat=-180, max_lat=180, min_lng=-180, max_lng=180, opts={})
      _random_by(min_lat, max_lat, min_lng, max_lng, opts)
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
