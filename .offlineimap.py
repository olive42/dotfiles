#!/usr/bin/python

import re, os

def get_password_emacs(machine, login, port):
    """Return password for the given machine/login/port.

    Your .authinfo.gpg file had better follow the following order, or
    you will not get a result.
    """
    s = "machine %s login %s port %s password ([^ ]*)\n" % (machine, login, port)
    p = re.compile(s)
    authinfo = os.popen("gpg -q -d ~/.authinfo.gpg").read()
    return p.search(authinfo).group(1)
