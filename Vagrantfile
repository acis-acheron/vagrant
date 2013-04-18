def base_config(config)
    config.vm.synced_folder "vm_data", "/config_data", :nfs => true
    config.vm.provision :shell, :inline => "cd /config_data; sh main.sh"
   
    config.vm.provider :virtualbox do |vbox|
        vbox.customize ["modifyvm", :id, "--memory", 256]
    end
end

Vagrant.configure("2") do |config|
    config.vm.box = "squeeze32-nfs-mono"
    config.vm.box_url = "/opt/squeeze32-nfs-mono.box"
       
    config.vm.define :alpha do |alice_config|
        base_config alice_config
        config.vm.network :private_network, ip: "192.168.56.101"
        alice_config.vm.hostname = "vagrant-alpha"
    end

    config.vm.define :beta do |bob_config|
        base_config bob_config
        config.vm.network :private_network, ip: "192.168.56.102"
        bob_config.vm.hostname = "vagrant-beta"
    end
end

