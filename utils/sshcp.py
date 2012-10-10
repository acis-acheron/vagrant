"""
Provides utilities for scp-like file transfer over ssh with the ssh module. For
all functions:

- Local files can strings refering to the file path, or file objects
- Local directories must be strings refering the the directory path
- Remote files must be string file paths (obviously)
- If there is already something there, it'll get overwritten
- Relative paths are to the current working directory. On the remote side, that
  means relative to the home directory
- Destinations paths for files must be the full path (just a directory name
  won't do)
"""

from . import ssh
import io
import os
import tarfile
import tempfile

try:
    basestring
except NameError:
    basestring = str

send_file(peer, source, destination):
    if isinstance(source, basestring):
        source = io.open(source, mode="rb")
    with source:
        peer.check_call(["tee", destination], stdin=source, stdout=os.devnull)

recv_file(peer, source, destination):
    if isinstance(destination, basestring):
        destination = io.open(f, mode="wb")
    with destination:
        peer.check_call(["cat", source], stdout=destination)

send_dir(peer, source, destination):
    with tempfile.TemporaryFile("w+b") as tar_file:
        tar_object = TarFile(fileobj=tar_file)
        tar_object.add(source, arcname=".")
        peer.check_call(["tar", "--extract", "--file", "-",
                         "--directory", destination], stdin=tar_file)

recv_dir(peer, source, destination):
    with tempfile.TemporaryFile("w+b") as tar_file:
        peer.check_call(["tar", "--create", "--file", "-",
                         "--directory", source, "."], stdout=tar_file)
        tar_object = TarFile(fileobj=tar_file)
        tar_object.extractall(path=destination)
