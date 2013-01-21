# performs the common configuration tasks on the VMs
def base_config(config)
    config.vm.box = "squeeze32"
    config.vm.box_url = "http://mathie-vagrant-boxes.s3.amazonaws.com/" \
                        "debian_squeeze_32.box"
    config.vm.customize ["modifyvm", :id, "--memory", 256]
    config.vm.share_folder "data", "/config_data", "vm_data"
                           # identifier, guest path, host path
    # VirtualBox 4.1.8 disables symlinks for shared data folders by default
    # This breaks svn, and basically every other POSIX-compatible program.
    config.vm.customize ["setextradata", 
                         :id,
                         "VBoxInternal2/SharedFoldersEnableSymlinksCreate/data",
                         "1"]
    config.vm.provision :shell, :inline => "cd /config_data; sh main.sh"
end
    

Vagrant::Config.run do |config|
    config.vm.define :alice do |alice_config|
        base_config alice_config
        alice_config.vm.network :hostonly, "192.168.56.101"
        alice_config.vm.host_name = "vagrant-alice"
    end
    
    config.vm.define :bob do |bob_config|
        base_config bob_config
        bob_config.vm.network :hostonly, "192.168.56.102"
        bob_config.vm.host_name = "vagrant-bob"
    end
end

