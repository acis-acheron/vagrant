"""
Continuously searches for hosts on the vboxnet0 subnet, getting both their IPv4
addresses and their hostnames.

Performance is poor, but it doesn't require anything like mdns, and works
without root.
"""

from . import ssh
import subprocess
import threading
try:
    import queue
except ImportError:
    import Queue as queue # python 2
import itertools

_hosts = {}                       # in the format {hostname: [ipv4_addresses]},
                                  # as one hostname may match multiple machines
_ip_addresses = {}                # in the format {ipv4_address: hostname}
_scan_lock = threading.Lock()     # used for pausing the scan
_dict_lock = threading.Lock()     # used to maintain the consistency of _hosts
                                  # and _ip_addresses
_scan_paused = False              # keeps us from re-requesting a lock
_queued_addresses = queue.Queue() # addresses to scan as soon as possible

def resume():
    if _scan_paused:
        _scan_lock.release()
    _scan_paused = False

def pause():
    """Will block for up to about a second."""
    if not _scan_paused:
        _scan_lock.aquire()
    _scan_paused = True

def queue_ip_address(ip_address):
    """
    Queues the IP address to be the next one scanned (even when out of order)
    """
    _queued_addresses.put_nowait(ip_address)

def get_ip_addresses():
    """
    Gives a set of all the currently known hosts' IP addresses. Results may be
    inaccurate. We may think that there are clients there that aren't actually
    there anymore, or not know about clients that do actually exist.
    """
    with _dict_lock:
        return set(_ip_addresses.keys())

def get_hostnames():
    """
    Gives a set of all the currently know hosts' hostnames. Results may be
    inaccurate. We may think that there are clients there that aren't actually
    there anymore, or not know about clients that do actually exist.
    """
    with _dict_lock:
        return set(_hosts.keys())

def get_by_hostname(hostname):
    """
    Returns a list of the IP addresses associated with a hostname. This must be
    a list, as multiple hosts could use the same hostname (although rare).
    """
    with _dict_lock:
        return _hosts.get(hostname, [])

def get_by_ip_address(ip_address):
    """
    Returns the hostname associated with an IPv4 address.
    """
    return _ip_addresses.get(ip_address, None)

def _scan_iter():
    """
    Acts as an iterator for _scan_thread that loops over the ip address range
    for vboxnet0.
    """
    ip_addr_prefix = "192.168.56."
    ip_addr_range = itertools.cycle(range(101, 255)) # 255 is not included as
                                                     # it is used for broadcast
    lock = threading.Lock()
    while True:
        try:
            yield _queued_addresses.get(block=False)
        except queue.Empty:
            yield "%s%s" % (ip_addr_prefix, next(ip_addr_range))

def _scan_thread_target():
    for ip_addr in _scan_iter():
        with _scan_lock:
            try:
                hostname = _lookup_hostname(ip_addr)
            except KeyError:
                continue

        with _dict_lock: # write it back
            old_hostname = None
            if ip_addr in _ip_addresses:
                # We discovered something about this ip_address before, but
                # something may have changed
                old_hostname = _ip_addresses[ip_addr]
                _hosts[old_hostname].remove(ip_addr)
                if len(_hosts[old_hostname]) == 0:
                    del _hosts[old_hostname]

            # update our entry
            _hosts[hostname] = _hosts.get(hostname, set()).add(ip_addr)
            _ip_addresses[ip_addr] = hostname

def _lookup_hostname(ip_address, timeout=2):
    """
    Given an IP address, returns the hostname of the system, or raises an
    KeyError. This function is blocking, and could possibly raise an exception
    even if the host is there, as it could time out.
    """
    try:
        return ssh.Client(ip_address, username="user").check_output(
            ["hostname"], ssh_kwargs={"ConnectTimeout": timeout}
        ).decode().strip()
    except subprocess.CalledProcessError:
        raise KeyError("No host found at the IP address %s given." % ip_address)

# start scanning
_scan_thread = threading.Thread(target=_scan_thread_target,
                                name="vbox_ssh_hosts_scan")
_scan_thread.daemon = True # exit when the program exits
_scan_thread.start()

if __name__ == "__main__":
    import time
    import curses
    screen = curses.initscr()
    try:
        curses.noecho() # hide keyboard input
        curses.curs_set(0) # hide the cursor
        pulse = itertools.cycle(["", ".", "..", "..."])
        while True: # crappy polling loop as we don't have an event system
            screen.erase()
            i = 0 # represents the current line we're on
            if not get_ip_addresses():
                screen.addstr(i, 0, "No hosts found yet")
                i += 1
            else:
                for ip_address in get_ip_addresses():
                    prefix = "%s: " % get_by_ip_address(ip_address)
                    screen.addstr(i, 0, prefix)
                    screen.addstr(i, max(20, len(prefix)), ip_address)
                    i += 1
            screen.addstr(i, 0, next(pulse))
            i += 1
            screen.refresh()
            time.sleep(.33)
    except KeyboardInterrupt:
        pass # exit silently
    finally:
        curses.curs_set(2)
        curses.echo()
        curses.endwin()
