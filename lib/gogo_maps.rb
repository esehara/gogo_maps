require "gogo_maps/version"

module GogoMaps
  # @param Hash opts - to support below Ruby1.9x.
  def self.parameters(opts={ address: nil, latlng: nil, language: :ja, sensor: false })
    fail 'Should provide either address or latlng' unless opts[:address] || opts[:latlng]
    opts.inject('?') do |param, (k, v)|
      next unless v
      param += "#{k}=#{v}&"
    end
  end
end
