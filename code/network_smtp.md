# SMTP Notes

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>

* * *

The information on this page were configurations I needed to make on my local
home server/desktops to send mail.  The server has automated jobs and needs to
contact/notify me when ever the scripts detects errors or issues that needs my
attention.  STMP normally works out of the box... but...

* * *

Due to ISP BLOCKING SMTP outbound port, to get "send" mail working from home:
- need to relay it with (for example) google's smtp servers
- `/etc/hostname` and `/etc/mailname` can be **_internal_** hostnames
	- i.e. does not need to be accessible from external networks

However, if ISP was not blocking SMTP port, then hostname will need to be **_valid_**:
- Many SMTP relay and end points will try to verify **From:** address to help curb spamming

NOTE: **USE _ALT_ EMAIL ACCT** while configuring login/passwd for relay
- again, this should be a **_secondary_** account

AGAIN: **!!! DO NOT USE PRIMARY EMAIL ACCT !!!**
```
passwords are written in the **CLEAR** in these config files
--- so yes, email will come "from" this alt acct ---
[ prevent accidental primary account exposure when doing
  things like tar'ing folder for archival purposes ]
```

Remember, this is for automated notifications, so using an alternate email account
can help give messages instant recognisability that may require immediate attention.

* * *

## DEBUGGING:
send a test msg (or use "email verification" mode):
```sh
echo "msg body" | mail -s "msg subj" username@gmail.com
```

if things still bomb, make sure to look at log files:
```sh
sendmail -bv username@gmail.com		# "email verification": ACL test - does not go in any inbox
cat /var/log/mail.log | tail -20
```

* * *

## EXIM:

just follow these instructions: (pretty much works right out of the box)
- [Configuring exim4 in Ubuntu to use GMail for SMTP](http://www.manu-j.com/blog/wordpress-exim4-ubuntu-gmail-smtp/75/)

- no need to do any thing with the [ `/etc/exim4/passwd.client` ] file (as some of the comments alluded to...)

- get TLS working with instructions from: [Let's Encrypt Certificates with Other Services](https://www.jedwarddurrett.com/20160604162607.php)
	- scroll down to EXIM

handy commands while testing:
```sh
sudo mailq                                    # show mail queue
sudo exiqgrep -z -i | sudo xargs exim -Mrm    # nuke all msgs in queue
```

* * *

## POSTFIX:

the following may be needed: **nuke existing postfix install**
and then **re-install** it to start with a clean slate.
```sh
sudo apt-get purge postfix
sudo aptitude install postfix
sudo dpkg-reconfigure postfix
```

and then follow these instructions:
- [How to Secure Postfix Using Let’s Encrypt](https://www.upcloud.com/support/secure-postfix-using-lets-encrypt/)

handy commands while testing:
```sh
mailq                    # show mail queue
sudo postsuper -d ALL    # nuke all msgs in queue
```

more resources:
- [Hardening Postfix For ISPConfig 3](http://www.howtoforge.com/hardening-postfix-for-ispconfig-3)


* * *

## SENDMAIL:

these seems like it might work (don't use sendmail in general, but, jic)...
- [How To Install And Configure Sendmail On Ubuntu](https://kenfavors.com/code/how-to-install-and-configure-sendmail-on-ubuntu/)
- [Let's Encrypt with Apache, dovecot, and sendmail](https://evermeet.cx/wiki/Let%27s_Encrypt_with_Apache,_dovecot,_and_sendmail)

* * *

## aliases:

[A Quick and Easy Way to Set Up a Mailing List](http://linuxgazette.net/issue72/teo.html)

```
# --- start of example entries in /etc/aliases ---
# simple aliases to an address
root: johndoe, johndoe@domain.tld
john: johndoe@another.domain.tld, johndoe@some.where.else

# example of a mailing list in aliases file
the_project: john, jane, bob@example.net
# but, use an external file to keep mailing lists under control...

# send mail to address, addresses in a file and to a file
announce: johndoe, :include: /etc/Exim/staff,
        /var/mail/log/announce

# target can be piped to a command
majordomo:  "|/usr/mail/majordomo ..."
autohelp:	"|/usr/etc/autohelp ..."
ppp-list:	"|/usr/local/bin/gateit local.lists.ppp"
# --- end of examples ---
```

after editing /etc/aliases, run the command:

```
newaliases                  # sendmail
postaliases /etc/aliases    # postfix
<no cmd>                    # exim
```

example email list from the [ :include: ] directive

```
# --- start example /etc/Exim/staff ---
johndoe@example.com
janedoe@example.org
bob@example.net
# --- end example /etc/Exim/staff ---
```

* * *




<style>
.note1                    { font-size: 11px; }
.markdown-body pre code   { font-size: 80%; }
</style>

