{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf760
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0  \
pocd_nodes = [\
	\{ :host => "vm1-template", :ip => "10.10.45.9", :box => "boxcutter/centos67", :ram => 1024, :cpu => 1, :gui => false \},\
	\{ :host => "vm2-template2", :ip => "10.10.45.10", :box => "boxcutter/centos67", :ram => 2048, :cpu => 2, :gui => false \},\
]\
\
\
varDomain = "poc-d.internal"\
varRepository = "F:/VAGRANT/REPOSITORY/"\
\
Vagrant.configure("2") do |config|\
\
    config.hostmanager.enabled = true\
    config.hostmanager.manage_host = true\
    config.hostmanager.manage_guest = true\
    config.hostmanager.ignore_private_ip = false\
    config.hostmanager.include_offline = true\
 \
	pocd_nodes.each do |pocd_node|\
\
		config.vm.define pocd_node[:host] do |pocd_config|\
\
			pocd_config.vm.box = pocd_node[:box]\
			pocd_config.vm.box_version = "2.0.14"\
			\
			pocd_config.vm.network "private_network", ip: pocd_node[:ip], :netmask => "255.255.255.0"\
			pocd_config.vm.hostname = "#\{pocd_node[:host]\}.#\{varDomain\}"\
			# pocd_config.vm.hostname = pocd_node[:host] + "." + varDomain\
\
		    pocd_config.hostmanager.aliases = "#\{pocd_node[:host]\}"\
\
			pocd_config.vm.provider :virtualbox do |v|\
				v.name = pocd_node[:host].to_s\
				v.gui = pocd_node[:gui]\
\
				v.customize ["modifyvm", :id, "--memory", pocd_node[:ram].to_s ]\
				v.customize ["modifyvm", :id, "--cpus", pocd_node[:cpu].to_s ]\
			end\
\
			pocd_config.vm.synced_folder varRepository, "/repository", \
				id: "repository",\
				owner: "vagrant",\
				group: "vagrant"\
\
		    pocd_config.vm.provision :shell, :path => "java/provision_for_java.sh"\
\
		end\
	end		\
end\
}