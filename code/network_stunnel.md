# stunnel Notes

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://github.com/nickshin/CheatSheets/>

* * *

I have tried a few VPN solutions, _(such as PPP-SSH & OpenVPN)_
eons ago and found that they have a horrendous amount of setup that touches
some system files _(/etc/hosts & /etc/resolv.conf)_ and
running commands that require super user access:

| command | notes |
| --- | --- |
| **iptables** | modify firewall rules |
| **route add** | change the routing tables |
| **mknod + modprobe** | create a network device |
| **ifconfig** | assigning an IP address to the new device |
| **pty** | pseudo terminal |

These are all basically
[ssh-based virtual private network](http://www.freebsd.org/cgi/man.cgi?query=ssh#SSH-BASED_VIRTUAL_PRIVATE_NETWORKS)
tunnelling.  And it seemed like an overkill solution for what I needed.

stunnel has a very simple way to create an encrypted channel between two
networked computers.  No system files or super user commands are required
to make this work.

[ssh TCP forwarding](http://www.freebsd.org/cgi/man.cgi?query=ssh#TCP_FORWARDING)
works the same way.  But "stunnel is running as it's own daemon, you can use
this port forward without first establishing the ssh connection." _-- [stunnel.org](http://www.stunnel.org/examples/generic_tunnel.html)_

_( A fun read: [SSH Tunnels: Bypass (Almost) Any Firewall](http://polishlinux.org/apps/ssh-tunneling-to-bypass-corporate-firewalls/).)_

* * *

To double check your ssh server's fingerprint:

```
ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key.pub
```

* * *

stunnel code snipets
_(see [man page](http://www.stunnel.org/faq/stunnel.html) for details on these options)_:

- stunnel_server.conf

```ini
foreground = yes
client = no
cert = /etc/ssl/stunnel/stunnel.pem
verify = 3
[10081]
accept = 10080
connect = 10081
; another service can be added here...
```

- stunnel_client.conf

```ini
foreground = yes
client = yes
cert = /etc/ssl/stunnel/stunnel.pem
verify = 3
[10080]
accept = 10081
connect = 10.11.12.13:10080
; more service options can be added here...
```

Then, execute on the respective computers:

```
user@server:~# stunnel stunnel_server.conf
user@client:~# stunnel stunnel_client.conf
```

* * *

