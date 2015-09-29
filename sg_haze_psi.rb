require_relative 'lib/psi'

module SGHaze_PSI
  class SGHazePSI
    psi = SGHaze_PSI::PSI.new
    psi.process_dataset('pm2.5_update')
  end
end