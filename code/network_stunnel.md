# stunnel Notes

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>

* * *

I have tried a few VPN solutions, <span class="note1">(such as PPP-SSH & OpenVPN)</span>
eons ago and found that they have a horrendous amount of setup that touches
some system files <span class="note1">(/etc/hosts & /etc/resolv.conf)</span> and
running commands that require super user access:

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
works the same way.  But "stunnel is running as it's own daemon, you can
use this port forward without first establishing the ssh connection."
<span class="note1">-- [stunnel.org](http://www.stunnel.org/examples/generic_tunnel.html)</span>

<span class="note1">( A fun read:
[SSH Tunnels: Bypass (Almost) Any Firewall](http://polishlinux.org/apps/ssh-tunneling-to-bypass-corporate-firewalls/).
)</span>

* * *

To double check your ssh server's fingerprint:
```
ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key.pub
```

* * *

stunnel code snipets
<span class="note1">(see [man page](http://www.stunnel.org/faq/stunnel.html) for details on these options)</span>:

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




<style>
.note1                    { font-size: 11px; }
.markdown-body pre code   { font-size: 80%; }
</style>

