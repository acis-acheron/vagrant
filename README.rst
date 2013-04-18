==========
VM Builder
==========

This tool is intended to allow us to easily rebuild our strongswan/groupvpn VMs.
We should ideally:

1. Clone our base VM (and its attached SATA disk)
2. Modify our clone, running shell scripts to compile and configure strongswan
   and groupvpn
3. Clone that clone again (we only need to do this once more), giving us two
   mostly configured machines
4. Apply machine-specific configurations to both
5. ...
6. Profit!

In a diagram::
    
    base_machine  (remains unmodified)
          |       (inital clone)
        alice     (modifications happen)
         / \      (clone once more to make bob)
    alice   bob   (make machine-specific modifications to both)
         ...
    $$$PROFIT$$$  (aquire currency, attract females)

Running modules
===============

Some modules have certain functionality that can be used to test the modules,
or, in some cases, can be used as a simple tool. You can run a module with::
    
    python -m utils.hosts
