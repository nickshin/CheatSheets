# Wireguard Notes

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://github.com/nickshin/CheatSheets/>

* * *

**personally**, wireguard looks almost like how [stunnel](code/network_stunnel.md)
works -- but, with the following distinctions:
- runs in **UDP** (YAY!)
- requires **superuser** to run (BOO!)
	- well... boo for "individual use" (see [Mosh](https://mosh.org) for an alternative)
	- but, can understand if routes and dns needs to be configured

**config file** setup is also a little "too" manual.  (i'm not afraid of
this -- but) this might become unwieldy if you have hundres of peers to maintain
(which dhcp is normally used to handle this).  i like the control -- so YMMV.

from an **enterprise** point of view, wireguard, in my opinion:
- needs **at least** some form of 2(nd)FA
	- e.g. `user access control` -- in terms of login &amp; password
	- this way, public key exchanges is not the `only` thing sent between admins
	  and users in a `single` communication channel

**public/private keys**:
- i understand that "2FA isn't necessary" because public/private key communications
  are the back bone to many encryption communications
	- however, i would counter that this can be subject to MITM attacks
	- or (and more likely) the absent minded user(s) who leaves their conf file
	  easily (world) readable (you know... windoze users)
- to which, again, i would relegate this for "individual usse" only (e.g. stunnel)
- or for "local network" connections -- where network security is a fairly controlled environment

with **remote network** (with possibily large numbers of) connections, i do not
feel using just a pair of keys is enough:
- maybe with rigorous **periodic cycling** out old public/private keys with new ones,
  this may be enough
- but, **wireguard needs to be shutdown and restarted** whenever **ANY** keys
  are changed or added
	- (**no conf reload** as far as i can tell -- as of 2020-05-01)
	- not very enterprisy
		- but, clients are expected to reconnect upon connection errors like this...
		  so it might not really be an issue...
	- (OpenVPN doesn't support conf reload either -- but does support PAM plugins
	   which mitigates this issue)

NOTE TO SELF: need to test:
- (if single peer file from multiple computers can connect to wireguard
   server -- a la `duplicate-cn` in OpenVPN -- or will we need individual
   peers settings for each devices a remote user may have? yikes!)

finally, while a public/private key generator and uploading/copying the public key
to the wireguard server (as well as a way to obtain any new server key updates) is quite
doable now -- but, accessing (to upload and/or obtain keys) the wireguard server...
will still need to be interacted with...  oh... wait for it... username and password...

* * *

## SERVER

- pretty much all the instructions you need:
	- <https://www.wireguard.com/install/>

- these were were also very helpful:
	- <https://www.kali.org/tutorials/wireguard-on-kali/>
	- <https://securityespresso.org/tutorials/2019/03/22/vpn-server-using-wireguard-on-ubuntu/>

- the following are notable excerpts and findings:

#### debian
```sh
# ubuntu < 19.10
add-apt-repository ppa:wireguard/wireguard
apt-get update # you can skip this on Ubuntu 18.04

# kali needs the following two installs:
apt-get install libelf-dev linux-headers-$(uname -r) build-essential pkg-config
apt-get install bc # missing from wireguard compilation docs

# finally
apt-get install wireguard resolvconf
```

#### arch
```sh
# if kernel < 5.6 need to build module manually
#     note: manjaro will not install wireguard-lts
#           and has problems building wireguard-dkms+linux-headers
#     need to compile from source:
#     - https://www.wireguard.com/compilation/
pacman -S linux-headers base-devel pkg-config
# else
pacman -S wireguard-tools
```

#### kernel module

load the wireguard kernel module, configure it and run it:
```sh
modprobe wireguard
lsmod | grep wireguard

cd /etc/wireguard
umask 077
wg genkey | sudo tee privatekey | wg pubkey > publickey

	# SERVER CONFIG
	# see: https://try.popho.be/wg.html
	#     server wg0.conf details
	#
	# excellent examples on how to setup server with multiple
	# expected peers and even peers with network ranges
	# - think of this (peer's AllowedIps) as the server's route setup (to the peers)

wg-quick up wg0
wg

# set it to start on boot
systemctl enable wg-quick@wg0
```

## SERVER-FIREWALL

allow wireguard traffic on default port:

```sh
ufw allow 51820/udp
ufw status verbose
```

* * *

## CLIENT

all the same steps as **SERVER** (but do not need firewall step):

```sh
	# CLIENT CONFIG
	# see: https://try.popho.be/wg.html
	#     client wg0.conf details
	#
	# excellent examples on how to setup peers with:
	# - route everything to server
	# - define network zones/ranges and route those specific ones to the server
	# - think of this (server's AllowedIps) as the peer's route setup (to the server)
```

* * *

## route

sometimes `route` nor `iptables -L` will not show the **routes** going through `wg0`
- can use the folllowing to make this show up:

```sh
# https://vincent.bernat.ch/en/blog/2017-ipv4-route-lookup-linux#builtin-tables
ip route show table local
```

* * *

