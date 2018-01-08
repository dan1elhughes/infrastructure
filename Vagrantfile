$nodes = 1

ansible = <<EOF
add-apt-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible

ln -sf /vagrant/ansible /home/ubuntu
ln -sf /vagrant/ansible/hosts.ini /etc/ansible/hosts
ln -sf /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg

chmod 600 /home/ubuntu/.ssh/id_rsa
EOF

autoCD = <<EOF
echo cd ansible > /home/ubuntu/.bash_aliases
EOF

enableSsh = <<EOF
mv /tmp/authorized_keys /root/.ssh/authorized_keys
chown root: /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
EOF

createShortcuts = <<EOF
cat > /home/ubuntu/.ssh/config << END
Host node1
	User xes
	HostName 192.168.10.10
END
EOF

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/xenial64"

	config.vm.define "master", primary: true do |master|
		master.vm.hostname = "master"
		master.vm.network :private_network, ip: "192.168.10.1"
		master.vm.network :forwarded_port, guest: 22, host: 2200, id: "ssh"
		master.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
		master.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
		master.vm.provision "shell", inline: ansible
		master.vm.provision "shell", inline: autoCD
		master.vm.provision "shell", inline: createShortcuts
	end

	(1..$nodes).each do |i|
		config.vm.define "node#{i}" do |node|
			node.vm.hostname = "node#{i}"
			node.vm.network :private_network, ip: "192.168.10.#{9 + i}"
			node.vm.network :forwarded_port, guest: "22", host: "#{2219 + i}", id: "ssh"
			node.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/tmp/authorized_keys"
			node.vm.provision "shell", inline: enableSsh
		end
	end
end
