begin
	Facter.fqdn
rescue
	Facter.loadfacts()
end
Facter.add("cfqdn") do
  setcode do
     identity = Facter.value('hostidentity')
     fqdn = Facter.value('fqdn')
     [fqdn,identity].join('::')
  end
end
