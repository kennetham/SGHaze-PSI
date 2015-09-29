require 'httparty'
require 'nokogiri'
require 'yaml'

module SGHaze_PSI
  class PSI
    def initialize
      @CONFIG = YAML.load_file("lib/config/config.yml")
    end

    private

    def retrieve_dataset(dataset)
      response = HTTParty.get("http://www.nea.gov.sg/api/WebAPI?dataset=#{dataset}&keyref=#{@CONFIG[0][:NEA_API_KEY]}")

      response
    end

    public

    def process_dataset(dataset)
      psi_hash = {}
      response = retrieve_dataset(dataset)

      xml_results = Nokogiri::XML(response.body)
      xml_results.xpath("//channel//region").each do |root|
        id = root.xpath('id').text
        lat = root.xpath('latitude').text
        lon = root.xpath('longitude').text

        root.xpath('record').each do |child|
          timestamp_formatted = DateTime.strptime(child['timestamp'], '%Y%m%d%H%M%S')
          timestamp = timestamp_formatted.strftime("%H%M")

          child.xpath('reading').each do |grandchild|
            type = grandchild['type']
            value = grandchild['value']

            json = [:id => id,
                    :lat => lat,
                    :lon => lon,
                    :timestamp => timestamp,
                    :psi_type => type,
                    :psi_value => value].to_json

            psi_hash[id] = json
          end
        end
      end

      psi_hash
    end
  end
end