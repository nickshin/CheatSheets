# Rsync Notes

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this code found in this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>

* * *

rsync is a pretty simple tool to use.  In addition to the
[man page](http://www.samba.org/ftp/rsync/rsync.html),
here are some useful pages I found very helpful (to digest) that I
sometimes refer to every now and then:

- [rsync tips &amp; tricks](http://web.archive.org/web/20100728130038/http://sial.org/howto/rsync/)
<span class="note1">(archive.org)</span> -- [rsync tips &amp; tricks](http://sial.org/howto/rsync/) <span class="note1">(original)</span>
	- notes on trailing slashes - very important to know the differences
	- using it with ssh for remote copying interactively (i.e. with password challenge)
	- setting it up with ssh for unattended (i.e. no password challenge) periodic backups
- [rsync with SSH](http://troy.jdmz.net/rsync/index.html)
	- tips &amp; tricks above covered this (unattended periodic backups), but this
		 page goes in to a little more detail by spelling out all of the steps
		 with a nice ssh command filter in a separate file that's very handy for
		 customization purposes.

* * *

### most used snipets.

```sh
# copy
rsync --verbose --progress --stats --recursive --links --perms --times  src/ dst/

# delete
rsync --verbose --progress --stats --recursive --links --perms --times --delete src/ dst/

# ssh (interactively)
rsync --verbose --progress --stats --recursive --links --perms --times --compress -e ssh src/ dst/
rsync --verbose --progress --stats --recursive --links --perms --times --compress -e 'ssh -ax' src/ dst/

# USB drives:
# NOTE: use --checksum to really ensure files are n'sync
# NOTE: may need to be mounted with the sync option
#     > sudo mount -o remount,sync /media/<path>
# NOTE: may need to be told to use relative path names
#     -R, --relative
rsync --verbose --progress --stats --recursive --links --perms --times --delete --checksum --relative src/ dst/
```

* * *

### Scripting snipets.

```sh
#DRY_RUN="--dry-run"
DRY_RUN=

OPTS_VERBOSE="$DRY_RUN --verbose --progress --stats"
OPTS_SYNC="--recursive --links --perms --times"
OPTS_REMOTE="--compress -e 'ssh -ax'"

rsynccmd="rsync $OPTS_VERBOSE $OPTS_SYNC"
```

* * *

### Excludes and Filters notes:

- Since rsync is normally "inclusive", the notes here are to "exclude" files
- If certain files are "excluded" and you wish to keep it "included",
then either re-write the exclude rules/patterns or break down and use the `--include` (+) options
- Thus note, the `--filter` notes below can also be used with `--exclude-file` and `--include-file entries`

```sh
--exclude-from=FILE     # read exclude patterns from FILE

the following can stack
--exclude=PATTERN       # inline file exclude: matching PATTERN
--filter=RULE           # inline file-filtering RULE

--filter='-'            # exclude        specifies an exclude pattern
--filter='+'            # include        specifies an include pattern
--filter='.'            # merge          specifies a merge-file to read for more rules
--filter=':'            # dir-merge      specifies a per-directory merge-file
--filter='H'            # hide           specifies a pattern for hiding files from the transfer
--filter='S'            # show           files that match the pattern are not hidden
--filter='P'            # protect        specifies a pattern for protecting files from deletion
--filter='R'            # risk           files that match the pattern are not protected
--filter='!'            # clear          clears the current include/exclude list (takes no arg)

FILTER_FILE="~/tmp/filter.txt"
cat << FILTER_DEV_EOF > $FILTER_FILE
-  *.o
-  *.so
-  *.a
- .*.d
-  *.obj
-  *.pch
-  *.exp
-  *.pdb
-  *.idb
-  *.plg
-  *.vpj
- debug/
- release/
FILTER_DEV_EOF
```

- `--exclude-from` defaults to (-)

```sh
EXCLUDES_FILE="~/tmp/excludes.txt"
cat << FILTER_PATTERNS_EOF > $EXCLUDES_FILE
CACHE/
Cache/
TMP/
TEMP/
temp/
FILTER_PATTERNS_EOF
```

- `--exclude` takes no filter rule options, it is always (-)

```sh
EXCLUDE_THESE="--exclude=~/tmp/ --exclude=~/browser/cache/"
```

- note the dot in `--filter=". xyz"`

```sh
$rsynccmd --delete $EXCLUDE_THESE --filter=". $FILTER_FILE" $src/ $dst/
$rsynccmd --delete $EXCLUDE_THESE --exclude-from=$EXCLUDES_FILE --filter=". $FILTER_FILE" $src/ $dst/
```

* * *



<style>
.note1                    { font-size: 11px; }
pre                       { margin-left: 2em; }
.markdown-body pre code   { font-size: 80%; }
</style>

