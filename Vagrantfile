Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/trusty64"
	config.vm.network "private_network", ip: "192.168.10.10"

	config.vm.provision "shell", path: "vagrant.sh"
end
