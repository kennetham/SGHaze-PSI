require 'httparty'
require 'nokogiri'
require 'yaml'

class PSI
  CONFIG = YAML.load_file("config/config.yml")
  response = HTTParty.get("http://www.nea.gov.sg/api/WebAPI?dataset=pm2.5_update&keyref=#{CONFIG[0][:NEA_API_KEY]}")

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