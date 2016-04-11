Vagrant.configure('2') do |config|
	config.vm.box = 'ubuntu/trusty64'

	config.vm.define 'master', primary: true do |master|
		master.vm.hostname = 'master'
		master.vm.network :private_network, ip: '192.168.10.1'
		master.vm.network :forwarded_port, guest: 22, host: 2200, id: 'ssh'
		master.vm.provision 'file', source: '~/.ssh/id_rsa', destination: '~/.ssh/id_rsa'
		master.vm.provision 'shell', path: 'master.sh'
	end

	config.vm.define 'web0' do |web0|
		web0.vm.hostname = 'web0'
		web0.vm.network :private_network, ip: '192.168.10.10'
		web0.vm.network :forwarded_port, guest: 22, host: 2220, id: 'ssh'
		web0.vm.provision 'shell', path: 'slave.sh'
	end

	config.vm.define 'web1' do |web1|
		web1.vm.hostname = 'web1'
		web1.vm.network :private_network, ip: '192.168.10.11'
		web1.vm.network :forwarded_port, guest: 22, host: 2221, id: 'ssh'
		web1.vm.provision 'shell', path: 'slave.sh'
	end
end
