# performs the common configuration tasks on the VMs
def base_config(config)
    config.vm.box = "squeeze32"
    config.vm.box_url = "http://mathie-vagrant-boxes.s3.amazonaws.com/" \
                        "debian_squeeze_32.box"
    config.vm.share_folder "data", "/config_data", "vm_data"
                           # identifier, guest path, host path
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
