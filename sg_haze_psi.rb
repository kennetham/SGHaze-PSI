require_relative 'lib/psi'

module SGHaze_PSI
  class SGHazePSI
    psi = SGHaze_PSI::PSI.new
    hash = psi.process_dataset('pm2.5_update')

    hash.each do |key, value|
      psi_json = JSON.parse(value)

      puts "[#{key[1, 2]}] #{psi_json[0]['timestamp']} : #{psi_json[0]['psi_value']}"
    end
  end
end