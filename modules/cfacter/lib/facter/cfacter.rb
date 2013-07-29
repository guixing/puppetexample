require 'digest/md5'

begin
	Facter.serialnumber
rescue
	Facter.loadfacts()
end
Facter.add("hostidentity") do
  setcode do
    identity = nil
    read_file = false
    begin
      identity_file = "/etc/hostidentity"
      identity = File.open(identity_file) { |f| f.readline } if File.exists?(identity_file)
      read_file = true if File.exists?(identity_file)
      # Second use serialnumber, if it exists
      unless identity
        identity = Facter.value('serialnumber') if Facter.value('virtual') != "xenu"
      end
      unless identity 
        identity = Facter::Util::Resolution.exec("ssh-keygen -lf /etc/ssh/ssh_host_rsa_key |awk '{print $2}' |sed -e 's/://g'")
        identity = "badidentity-" + identity if identity
      end
    rescue Exception
    end
    if read_file == true
        identity.strip
    else
        Digest::MD5.hexdigest(identity.strip)
    end
  end
end
