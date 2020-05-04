#!/bin/bash

#set -x # print commands
set -e # exit script on error


# ------------------------------------------------------------
# CUSTOM CONFIGURATIONS

IFWAN='eth0'

REQ_COUNTRY="US"
REQ_PROVINCE="California"
REQ_CITY="San Francisco"
REQ_ORG="Copyleft Certificate Co"
REQ_EMAIL="me@example.net"
REQ_ORGUNIT="My Organizational Unit"
REQ_CA_EXPIRE=3650
REQ_CERT_EXPIRE=1080
REQ_CERT_RENEW=30
REQ_CRL_DAYS=180
REQ_CN="TEST-VPN"

REMOTE='ovpn.example.com'
PUSH2CLIENT='
push "route 192.168.234.0 255.255.255.0"
push "route 10.123.1.0 255.255.255.0"
'
# the following may also be needed
#push "redirect-gateway def1"
#push "dhcp-option DNS 192.168.234.254"


ezrsa_ver="3.0.7" # last known working tested version with this script


# DO NOT USE THE FOLLOWING: (better to use --batch which allows --req-cn= to work)
#export EASYRSA_BATCH=1 # run: non interactive and silent


# ------------------------------------------------------------
# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-debian-10
# PREREQ: apt       install openvpn
# PREREQ: pacman -S install openvpn

if [[ $EUID -ne 0 ]]; then
	# i.e. for testing and dry-runs...
	#SUDO='sudo'
	SUDO='echo sudo'
else
	SUDO=
fi


# ------------------------------------------------------------
# ------------------------------------------------------------

fetch_ezrsa()
{
	# ------------------------------------------------------------
	# handy cert maker
	if [ ! -f EasyRSA-$ezrsa_ver.tgz ]; then
		wget https://github.com/OpenVPN/easy-rsa/releases/download/v$ezrsa_ver/EasyRSA-$ezrsa_ver.tgz
		tar zxf EasyRSA-$ezrsa_ver.tgz
	fi

	# housekeeping
	mkdir -p config-server/server	# "sudo cp" after inspection
	mkdir -p config-client/keys		# i.e. keep private
	mkdir -p config-client/files	# i.e. public files: send to users
	chmod -R 700 config-client
	chmod -R 700 config-server

	# configure
	if [ ! -f vars ]; then
		sed -E "
s/#(set_var EASYRSA_REQ_COUNTRY\s+)\".+/\1\"$REQ_COUNTRY\"/g
s/#(set_var EASYRSA_REQ_PROVINCE\s+)\".+/\1\"$REQ_PROVINCE\"/g
s/#(set_var EASYRSA_REQ_CITY\s+)\".+/\1\"$REQ_CITY\"/g
s/#(set_var EASYRSA_REQ_ORG\s+)\".+/\1\"$REQ_ORG\"/g
s/#(set_var EASYRSA_REQ_EMAIL\s+)\".+/\1\"$REQ_EMAIL\"/g
s/#(set_var EASYRSA_REQ_OU\s+)\".+/\1\"$REQ_ORGUNIT\"/g
s/#(set_var EASYRSA_CA_EXPIRE\s+).+/\1$REQ_CA_EXPIRE/g
s/#(set_var EASYRSA_CERT_EXPIRE\s+).+/\1$REQ_CERT_EXPIRE/g
s/#(set_var EASYRSA_CERT_RENEW\s+).+/\1$REQ_CERT_RENEW/g
s/#(set_var EASYRSA_CRL_DAYS\s+).+/\1$REQ_CRL_DAYS/g
s/#(set_var EASYRSA_REQ_CN\s+)\".+/\1\"$REQ_CN\"/g
" EasyRSA-$ezrsa_ver/vars.example > EasyRSA-$ezrsa_ver/vars
	fi
}


setup_server()
{
	PKI_SERVER='pki-server'
	PKI_DIR="--pki-dir=$PKI_SERVER"

	# ------------------------------------------------------------
	# create Server Certificate, Key, and Encryption Files
	./easyrsa $PKI_DIR --req-cn=${REQ_CN}-SERVER init-pki
	./easyrsa $PKI_DIR --batch gen-req ${REQ_CN}-SERVER nopass

	# dhparam key
	./easyrsa $PKI_DIR gen-dh
		# this can also be generated as:
		# openssl dhparam -out dh2049.pem 2048

	# tls-auth key
	openvpn --genkey --secret ta.key

	# ------------------------------------------------------------
	# configure OpenVPN server
#	cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz .
#	gzip -d server.conf.gz

	# WARNING: crt files are created in setup_ca()
	cat <<__EOF_SERVER_CONF > server.conf
# based on /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz

port 1194
proto udp
dev tun

ca server/ca.crt
cert server/${REQ_CN}-SERVER.crt
key server/${REQ_CN}-SERVER.key
tls-auth server/ta.key 0
dh server/dh.pem

server 10.8.0.0 255.255.255.0
$PUSH2CLIENT

duplicate-cn
keepalive 10 120

cipher AES-256-CBC
auth SHA256

user nobody
# linux
group nogroup
# arch
#group nobody

persist-key
persist-tun

# client <-> virtual IP address
# If OpenVPN goes down or is restarted, reconnecting
# clients can be assigned the same virtual IP address
# from the pool that was previously assigned.
ifconfig-pool-persist /var/log/openvpn/ipp.txt

# current connections, truncated and rewritten every minute.
status /var/log/openvpn/openvpn-status.log

# "log" will truncate the log file on OpenVPN startup,
# "log-append" will append to it.
#  Use one or the other (but not both).
log         /var/log/openvpn/openvpn.log
;log-append  /var/log/openvpn/openvpn.log

# 0 is silent, except for fatal errors
# 4 is reasonable for general usage
# 5 and 6 can help to debug connection problems
# 9 is extremely verbose
verb 3

# Notify the client that when the server restarts so it
# can automatically reconnect.
explicit-exit-notify 1

# CUSTOM
management localhost 7505
#crl-verify server/crl.pem
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so openvpn

__EOF_SERVER_CONF

	# NOTE: when using openvpn-plugin-auth-pam.so -- to create
	# username password BerkeleyDB file with `db_load` command, see:
	# https://github.com/nickshin/CheatSheets/code/network_openvpn.md#with-pam_userdb

	# ..............................
	# copy conf & keys to server staging
	cp server.conf ../config-server/.
	cp $PKI_SERVER/private/${REQ_CN}-SERVER.key $PKI_SERVER/dh.pem ta.key ../config-server/server/.
}


setup_ca()
{
	PKI_CA='pki-ca'
	PKI_DIR="--pki-dir=$PKI_CA"

	# ------------------------------------------------------------
	# build CA
	./easyrsa $PKI_DIR --req-cn=${REQ_CN}-CA init-pki
	./easyrsa $PKI_DIR --batch build-ca nopass

	# CA cert files - from SERVER cert-req
	./easyrsa $PKI_DIR import-req pki-server/reqs/${REQ_CN}-SERVER.req ${REQ_CN}-SERVER
	./easyrsa $PKI_DIR --batch sign-req server ${REQ_CN}-SERVER

	# ------------------------------------------------------------
	# configure OpenVPN client
	cat <<__EOF_BASE_CONF > base.conf
# based on /usr/share/doc/openvpn/examples/sample-config-files/client.conf

client
proto udp
dev tun
nobind

remote $REMOTE 1194

resolv-retry infinite

user nobody
# linux
group nogroup
# mac and arch
#group nobody

persist-key
persist-tun

# these will be inlined
#ca ca.crt
#cert client.crt
#key client.key
#tls-auth ta.key 1

remote-cert-tls server
cipher AES-256-CBC
auth SHA256

# 0 is silent, except for fatal errors
# 4 is reasonable for general usage
# 5 and 6 can help to debug connection problems
# 9 is extremely verbose
verb 3

# CUSTOM
key-direction 1

# linux only
# script-security 2
# up /etc/openvpn/update-resolv-conf
# down /etc/openvpn/update-resolv-conf

auth-user-pass

__EOF_BASE_CONF

	# ..............................
	# copy CA crt files to staging
	cp $PKI_CA/ca.crt $PKI_CA/issued/${REQ_CN}-SERVER.crt ../config-server/server/.
	cp $PKI_CA/ca.crt ../config-client/keys/.
}


run_ovpn()
{
	# ------------------------------------------------------------
	# Starting and Enabling the OpenVPN Service

	${SUDO} cp -duvpr ../config-server/* /etc/openvpn/.
	# jic
	${SUDO} chown -R root.root /etc/openvpn/*
	${SUDO} chmod 644 /etc/openvpn/server.conf
	${SUDO} chmod 600 /etc/openvpn/*/*

	# "@server" corresponds to server.conf
	${SUDO} systemctl restart openvpn@server

	# use the following to help diagnose problems
#	echo 'hello' | systemd-cat
#	journalctl -xe

	# on clients, use:
#	route -n
#	route print
}


generate_ovpn_file()
{
	CLIENTFILE="${REQ_CN}-client-${1}"

	# ------------------------------------------------------------
	# Generating a Client Certificate and Key Pair

	# server key for ${CLIENTFILE}
	PKI_SERVER='pki-server'
	REQFILE="$PKI_SERVER/reqs/${CLIENTFILE}.req"
	if [ -f "$REQFILE" ]; then
		echo ERROR: file $REQFILE exists
		echo this should be revoked and a new client "NAME" used
		exit -1
	fi
	PKI_DIR="--pki-dir=$PKI_SERVER"
	./easyrsa $PKI_DIR gen-req ${CLIENTFILE} nopass

	# ${CLIENTFILE} cert file - from SERVER cert-req
	PKI_CA='pki-ca'
	PKI_DIR="--pki-dir=$PKI_CA"
	./easyrsa $PKI_DIR import-req $REQFILE ${CLIENTFILE}
	./easyrsa $PKI_DIR sign-req client ${CLIENTFILE}

	# ..............................
	# archive ${CLIENTFILE} crt and key pair
	cp $PKI_SERVER/private/${CLIENTFILE}.key ../config-client/keys/.
	cp $PKI_CA/issued/${CLIENTFILE}.crt ../config-client/keys/.

	# ..............................
	# finally, generate ovpn file
	cat <<__EOF_MAKE_OVPN_SH > make_ovpn.sh
#!/bin/bash

# First argument: Client identifier

cat base.conf \
    <(echo -e '<ca>') \
    ../config-client/keys/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ../config-client/keys/${CLIENTFILE}.crt \
    <(echo -e '</cert>\n<key>') \
    ../config-client/keys/${CLIENTFILE}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ta.key \
    <(echo -e '</tls-auth>') \
    > ../config-client/files/${CLIENTFILE}.ovpn
__EOF_MAKE_OVPN_SH
	chmod 700 make_ovpn.sh
	./make_ovpn.sh

	# ..............................
	# file to sent to user(s)
	${SUDO} cp ../config-client/files/${CLIENTFILE}.ovpn /etc/openvpn/client/.
    # jic
	${SUDO} chown root.root /etc/openvpn/client/${CLIENTFILE}.ovpn
	${SUDO} chmod 644 /etc/openvpn/client/${CLIENTFILE}.ovpn
}


setup_firewall()
{
	# ------------------------------------------------------------
	# Adjusting the Server Networking Configuration
	cat <<__EOF_SYSCTL_CONF
...
net.ipv4.ip_forward=1
...
__EOF_SYSCTL_CONF
	read -p "Press enter to continue "
	${SUDO} vi /etc/sysctl.conf
	# reload the sysctl.conf file
	${SUDO} sysctl -p

	# ------------------------------
	cat <<__EOF_UFW_BEFORE_RULES
...
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]

# allow traffic from OpenVPN client to ${IFWAN} --v
-A POSTROUTING -s 10.8.0.0/8 -o ${IFWAN} -j MASQUERADE

COMMIT
# END OPENVPN RULES
...
__EOF_UFW_BEFORE_RULES
	read -p "Press enter to continue "
	${SUDO} vi /etc/ufw/before.rules

	# ------------------------------
	cat <<__EOF_UFW
...
DEFAULT_FORWARD_POLICY="ACCEPT"
...
__EOF_UFW
	read -p "Press enter to continue "
	${SUDO} vi /etc/default/ufw

	# ------------------------------
	# don't forget to add these to sonicwall's port & services
	${SUDO} ufw allow 1194/udp
	${SUDO} ufw disable
	${SUDO} ufw enable
}



# ------------------------------------------------------------
# MAIN

fetch_ezrsa
cd EasyRSA-$ezrsa_ver
setup_server
setup_ca
run_ovpn

generate_ovpn_file 00

# reminders
setup_firewall

