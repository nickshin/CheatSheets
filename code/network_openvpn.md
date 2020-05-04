# OpenVPN Notes

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://github.com/nickshin/CheatSheets/>

* * *

the time has finally come for a need of an enterprise-grade secure tunneling network access.
- **OpenVPN 2** has come a long way since I last looked at this
- install with:

```sh
apt install openvpn
pacman -S openvpn
```

* * *

### replicating the [stunnel.md](network_stunnel.md) mechanism
with the following (e.g.) settings:
```sh
SERVERIP='10.200.0.1'
CLIENTIP='10.200.0.2'

DEVTYPE='tun'		# tunnel: ip traffic
#DEVTYPE='tap'		# terminal access point: ethernet frames (i.e. bridge any protocol)
```

side note: the following pages have good info on the differences between **TUN** and **TAP**
- [TUN TAP Design](https://en.wikipedia.org/wiki/TUN/TAP#Design)
- [Bridging and Routing](https://community.openvpn.net/openvpn/wiki/BridgingAndRouting#Bridgingvs.routing)
- [Should I use TAP or TUN for OpenVPN](https://serverfault.com/questions/21157/should-i-use-tap-or-tun-for-openvpn)

#### on same network
where security is **lax** (e.g. network shares)
```sh
# tunnel server
openvpn --ifconfig $SERVERIP $CLIENTIP --dev $DEVTYPE --proto tcp-server

# tunnel client
openvpn --ifconfig $CLIENTIP $SERVERIP --dev $DEVTYPE --proto tcp-client
```
#### remote network
with basic **secret key** (note: default is UDP)
```sh
# tunnel server
openvpn --genkey --secret secret.key
scp secret.key user@remote-client:/tmp/.
openvpn --ifconfig $SERVERIP $CLIENTIP --dev $DEVTYPE --secret secret.key

# tunnel client
openvpn --ifconfig $CLIENTIP $SERVERIP --dev $DEVTYPE --secret /tmp/secret.key --remote openvpnserver.tld
```

#### remote network - with username/password pair

see [user-access-control](#user-access-control----use-this) below

* * *

### config file tips

many CLI options can be used -- but, putting them in a configuration file makes it cleaner.

e.g.  when making an **N-way route** -- will need a server/client connection pair for each **N** sites
- i.e. use a GRAPH map instead of a SPOKE network (single point of failure)
```sh
	# servers
	openvpn --config server_1_to_2.conf
	# ...
	openvpn --config server_N_to_1.conf
	
	# clients
	openvpn --config client_1_to_2.conf
	# ...
	openvpn --config client_N_to_1.conf
```

note: config file can be included in config files
- e.g. put common information in `server-common.conf`
	- then in (e.g.) `server_1_to_2.conf`

```sh
config server-common.conf

server 192....
...
```

note: client configurations can have multiple **connection blocks**
```sh
client
dev tun

<connection>
remote ovpn1.example.com
proto udp
port 1194
</connection>

<connection>
remote ovpn2.example.com
proto tcp
port 1194
<c/onnection>

ca ...
...
```

* * *

### connection management

add the following to the **server.conf** file:
```sh
# dump details on every connection to status file
status /var/log/openvpn/openvpn-status.log
log /var/log/openvpn/openvpn.log   # TRUNCATES on every OpenVPN startup
#log-append /var/log/openvpn/openvpn.log

# read live data from the server
#management tunnel 23000 stdin     # DO NOT USE THIS -- blocks on server starts (asks to set password)
# ...
management localhost 7505          # use this instead -- does not block on startup
                                   # WARNING: ANYONE CAN JUST ACCESS THIS IF THEY KNOW THE PORT NUMBER
                                   #          ensure no one but admins are on the VPN box...
                                   #          really... no one else should be on this box...

# make use of Cert Revocation List (CRL) -- useful when multiple certs are used, especially temporary ones (e.g. contractors)
#crl-verify server/crl.pem         # NOT USING -- user access control is used to provide this on a per-user level
```

note: to "kick" users, remember that most clients will attempt to auto reconnect.
- disable user from user access control list and then kick

#### status file
one example to monitor number of clients connected to a server are saved to this file.
- in the above example: **/var/log/openvpn/openvpn-status.log**

#### server management interface

see: [openvpn.net - controlling a running ovpn process](https://openvpn.net/community-resources/controlling-a-running-openvpn-process/)
- or type `help` once connected

handy commands:
```sh
#telnet 127.0.0.1 23000 # changed port from default 23000 to use 7505 as seen in example from link above
#telnet 127.0.0.1 7505 # same as next line
telnet localhost 7505

# WARNING: ANYONE CAN JUST ACCESS THIS IF THEY KNOW THE PORT NUMBER
# WARNING: ANYONE CAN JUST ACCESS THIS IF THEY KNOW THE PORT NUMBER
# WARNING: ANYONE CAN JUST ACCESS THIS IF THEY KNOW THE PORT NUMBER
# i.e. harden and remote port access and ensure no one but admins are on the VPN box... really, no one else should be on this box...

# dump currently list of users (CLIENT LIST -- as well as ROUTING TABLE and GLOBAL STATS)
# note: this will be the same thing as `cat /var/log/openvpn/openvpn.status`
status

# kick a client (e.g. client commonname of: ovpnclient2)
kill ovpnclient2

# kick a client (e.g. IP:port)
kill w.x.y.z:a
```

#### Certificate Revocation List - CRL (NOT USING)

to add client **commonnames** (e.g. ovpnclient3) to the **CRL**:
```sh
./easyrsa revoke ovpnclient3
./easyrsa gen-crl
cp pki/crl.pem /etc/openvpn/server/.

# to see what's in the PEM file:
openssl crl -text -noout -in pki/crl.pem
```

must restart OpenVPN server when ever PEM file is updated
```sh
systemctl restart openvpn@server
```

* * *

### user access control -- USE THIS!!!

use unique **login** and **password** pairs via one of the following authentication plugins:
- PAM
- LDAP

first, add the following to the **base.conf** (client) file:
```sh
auth-user-pass
#auth-nocache
```

#### PAM authentication plugin

to find out where the plugin is located:
```sh
dpkg   -L  openvpn | grep '\bpam\b'
pacman -Ql openvpn | grep "\bpam\b"
```

then, add the following to the **server.conf** file:
```sh
# deb example:
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so openvpn

# arch example:
plugin /usr/lib/openvpn/plugins/openvpn-plugin-auth-pam.soa openvpn
```

##### with: pam_unix
create `/etc/pam.d/openvpn` with the following:
```sh
auth    required pam_unix.so shadow nodelay
account required pam_unix.so
```

interesting example: [To Extend the OpenVPN PAM service](https://www.cloudkb.net/openvpn-server-installation-configuration-linux/)

##### with: pam_userdb

prereqs:
```sh
apt install db-util
pacman -S db
```

create the BerkeleyDB file of username and password pairs:
```sh
#!/bin/bash

# as root:
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

# housekeeping
UPDB_DIR='/etc/openvpn/auth'
[ !-d $UPDB_DIR ] && mkdir $UPDB_DIR
cd $UPDB_DIR

# sample username and password pairs
echo <<__EOF_USERPASS_LIST > userpass.txt
user_1
pass_1
...
user_n
pass_n
__EOF_USERPASS_LIST

# convert to BerkeleyDB:
db_load -T -f userpass.txt -t hash userpass.db
chmod 0600 userpass.*
```

create `/etc/pam.d/openvpn` with the following:
```sh
# note, do not put '.db' extension -- this is implied
auth    sufficient pam_userdb.so db=/etc/openvpn/auth/userpass
account sufficient pam_userdb.so db=/etc/openvpn/auth/userpass
```

after updating `userpass.db` -- it is not necessary to restart openvpn -- however, test to ensure.

#### LDAP authentication plugin

prereqs:
```sh
apt install openvpn-auth-ldap
```

to find out where the plugin is located:
```sh
dpkg   -L  openvpn-auth-ldap | grep so
```

then, add the following to the **server.conf** file:
```sh
# deb example:
plugin /usr/lib/openvpn/openvpn-auth-ldap.so /etc/openvpn/auth/auth-ldap.conf
```

create `/etc/openvpn/auth/auth-ldap.conf` with:
```sh
cp /usr/share/doc/openvpn-auth-ldap/examples/auth-ldap.conf /etc/openvpn/auth/.
```
- edit `auth-ldap.conf` file and set up:
	- ActiveDirectory BindDN information
	- User BaseDN details
	- User Search Filter query

useful commands when working with LDAP servers:
```bat
:: the following came from:
:: https://serverfault.com/questions/78089/find-name-of-active-directory-domain-controller

:: current DC in use
echo %logonserver%
:: i.e.
set l

:: get list of DC names
nltest /dclist:%userdnsdomain%

:: find IPs of DCs
nslookup -type=all %userdnsdomain%

:: find IPs and port$ of DCs
nslookup -type=srv _ldap._tcp.%userdnsdomain%
:: same thing
nslookup -type=srv _ldap._tcp.dc._msdcs.%userdnsdomain%

:: find current BindDN string & current DN
gpresult /r
:: verbose
gpresult /z
```

after updating `auth-ldap.conf` -- it is not necessary to restart openvpn -- however, test to ensure.

* * *

### optimizations

cipher type used will effect throughput.

compression used will depend on the data being sent over the wire.

but, this all needs to be balance with:
- the number of clients
- how big the pipe from the ISP is
- how "powerful" the CPU is (i.e. encryption/compression)

personally, add more openvpn processes for clients to connect to:
- can be multiple processes on multi-processor machines
	- [load balancing failover configuration](https://openvpn.net/community-resources/implementing-a-load-balancing-failover-configuration/)
- across multiple machines
	- savvy clients can can then choose by switching to a different (e.g.) port
	- otherwise, change in the **base.conf** (client) file:

```sh
# the firewill will direct these ports to the different openvpn processes behind it
remote ovpn.mydomain 8000
remote ovpn.mydomain 8001
remote ovpn.mydomain 800n
```

* * *

### OVPN script hooks

#### script run order and user level

the following can be added to the bottom of the **server.conf** file:
```sh
script-security 2
cd /etc/openvpn/server/scripts
up                      root-script.sh
route-up                root-script.sh
down                    nobody-script.sh
client-connect          nobody-script.sh
client-disconnect       nobody-script.sh
learn-address           nobody-script.sh
tls-verify              nobody-script.sh
#auth-user-pass-verify  nobody-script.sh via-a-file
#auth-user-pass-verify  nobody-script.sh via-env
```

- **NOTE: auth-user-pass-verify**
	- this is a **SINGLE** user and password pair in a file or via env vars.
	- **DON'T USE THIS** -- use one of the [user access controls](#user-access-control) above

* * *

### putting everything together - with EasyRSA

see my handy shell script using EasyRSA with most of the configuration and commands plowed in from this page:
- [network_openvpn.sh](network_openvpn.sh)

* * *

### setting up client

very nice instructions list of instructions on how to setup OpenVPN clients at:
- [digitalocean.com - Installing the Client Configuration](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-debian-10#windows)
	- windows
	- macos
	- linux
	- iOS
	- android

* * *

