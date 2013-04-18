"""
Provides an almost API-compatible alternative to subprocess' call, check_call
and check_output functions, except as remote calls over ssh.

.. warning::
    If you want to be secure, make sure you make "ignore_known_hosts" False when
    calling one of the functions, and ensure you already have the host in your
    known hosts file. Otherwise there is a chance for a man-in-the-middle
    attack. For our case (dealing with VMs on the localhost) it doesn't matter.
"""

from __future__ import print_function
import subprocess

class Client:
    def __init__(self, host, username=None, password=None):
        """
        Constructor. If passed a password argument, sshpass should be installed.

        .. note::
            On Debian, sshpass can be installed with ``aptitude install
            sshpass``.
        """
        self.host = host
        assert username is not None
        self.username = username
        self.password = password

        # prepare the base set of arguments for future calls
        target_string = ("%s@%s" % (username, host)) if username else host
        if password is not None:
            self._base_arguments = ["sshpass", "-p", password, "ssh",
                                    target_string]
        else:
            self._base_arguments = ["ssh", target_string]
    
    @staticmethod
    def __to_shell(args):
        return ["sh", "-c", args]
    
    def __base_call(self, base_function, args, shell=False,
                    ignore_known_hosts=True, ssh_args=[], ssh_kwargs={},
                    **kwargs):
        """
        Implements the actual wrapping of the ssh call, allowing for a shared
        implementation between all the "call" functions.
        """
        if ignore_known_hosts:
            # Would require user input to accept the host
            ssh_kwargs["StrictHostKeyChecking"] = False
            ssh_kwargs["UserKnownHostsFile"] = "/dev/null"
        # disable ssh warnings (important when dealing with no host key checking
        ssh_kwargs["LogLevel"] = "quiet"

        for k, v in ssh_kwargs.items():
            # rewrite as: -o Key=Value -o Key2=Value2
            if v is True: v = "yes"
            elif v is False: v = "no"
            ssh_args += "-o", "%s=%s" % (k, str(v))

        # derive the base set of arguments to start ssh (remaining arguments are
        # what will actually be run on the remote host)
        program_args = self._base_arguments + ssh_args

        if shell:
            program_args += self.__to_shell(args) # wraps it as sh -c "args"
        else:
            program_args += args
        return base_function(program_args, shell=False, **kwargs)

    def call(self, *args, **kwargs):
        return self.__base_call(subprocess.call, *args, **kwargs)

    def check_call(self, *args, **kwargs):
        return self.__base_call(subprocess.check_call, *args, **kwargs)
    
    def check_output(self, *args, **kwargs):
        return self.__base_call(subprocess.check_output, *args, **kwargs)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(
        description="A simple tool for testing the ssh module"
    )
    parser.add_argument("username")
    parser.add_argument("--password", default=None)
    parser.add_argument("hostname")
    parser.add_argument("arguments", nargs="*", default=["echo", "success!"])

    args = parser.parse_args()
    print(Client(args.hostname, args.username, args.password)
          .check_output(args.arguments).decode(), end="")
