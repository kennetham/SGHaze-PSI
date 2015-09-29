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
      response = retrieve_dataset(dataset)

      xml_results = Nokogiri::XML(response.body)
      xml_results.xpath("//channel//region").each do |root|
        puts "ID : " + root.xpath('id').text
        puts "Latitude : " + root.xpath('latitude').text
        puts "Longitude : " + root.xpath('longitude').text

        root.xpath('record').each do |child|
          timestamp_formatted = DateTime.strptime(child['timestamp'], '%Y%m%d%H%M%S')
          puts "Timestamp : " + timestamp_formatted.strftime("%H%M")

          child.xpath('reading').each do |grandchild|
            puts "Type : " + grandchild['type']
            puts "Value : " + grandchild['value']
            puts
          end
        end
      end
    end
  end
end