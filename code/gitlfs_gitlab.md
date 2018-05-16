# Git-LFS Notes

written by Nick Shin - nick.shin@gmail.com<br>
this code found in this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/>

* * *

## Linux "server"

#### GETTING _GIT-LFS_ WORKING WITH GIT

- <https://github.com/github/git-lfs#getting-started>
	- install your flavor of `git-lfs`

```sh
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install
```

- start tracking lfs files (per project)

```sh
cd .../project.git
git lfs track "*.zip"
git add .
git commit -m 'lfs tracking zip files'
```
	- **NOTE**: this should also commit .gitattributes

- push will be done after setting up the server (next)...

#### Set up a server that is _LFS-API_ aware
- GitLab is pretty nice...
	- <https://about.gitlab.com/downloads/#ubuntu1404>

- `sudo vi /etc/gitlab/gitlab.rb`

	- to change the URL shown on webpages -- NOTE: **MUST USE FQDN** !!! postfix need this...

```sh
external_url 'http://gitbox.internal:8080'
```
		- e.g. can use alt-port
		- !!! keep an eye on `/var/log/gitlab/nginx/current` -- if port already in use -- this will be spammed in logfile

	- enable Git LFS -- both are **REQUIRED**

```sh
gitlab_rails['lfs_enabled'] = true
gitlab_rails['lfs_storage_path'] = "/var/opt/gitlab/git-data/lfs-objects"
# -- OR --
gitlab_rails['lfs_storage_path'] = "/mnt/nas/lfs-objects"
```

	- setting up different data storing directory
		- <http://stackoverflow.com/questions/19902417/change-the-data-directory-gitlab-to-store-repos-elsewhere/25876643#25876643>

```sh
# NO SYMLNKS
git_data_dir "/mnt/nas/git-data"
```

- have the changes take effect

```sh
sudo gitlab-ctl reconfigure
```

- **BUGFIX**: [GitLab Community Edition 8.4.4 9c31cc6]
	- if `gitlab_rails['lfs_storage_path']` is under `git_data_dir`

```sh
sudo chgrp git /var/opt/gitlab/git-data/lfs-objects
```

- for future reference...

```sh
sudo gitlab-ctl stop
    # do maintainence here...
sudo gitlab-ctl start
```

- or "did you turn it off and on again..."

```sh
sudo gitlab-ctl restart
```

* * *

## GitLab accounts

#### Setting up accounts on GitLab
- open browser to ( should match `external_url`):
	- `http://gitbox.internal`
	- `http://gitbox.internal:8080`
```
username: root
password: 5iveL!fe
```

- as `admin` create a [studio wide group]
- as `admin` try creating a project
	- i.e. project path:  `http://gitbox.internal:8080/` -&gt; [studio wide group] -&gt; `lfs-test`

###### <https://help.ubuntu.com/lts/serverguide/postfix.html>
- this does work... but mail will get sent to spam folder
	- **add gitbox.internal to the DNS**
	- **NOTE** admin can force confirm user

- as `normal` make account (you know, for testing)
- as `admin` add all (normal) users to [studio wide group]

###### MUST DO: setup ssh access (i.e. password-less connection)

```sh
ssh-keygen -t rsa -C "username@gitbox.internal" -f id_gitlab
cat id_gitlab.pub
# copy output to gitlab account [ profile settings -> ssh keys -> +add ssh key -> key ]
mv id_gitlab* ~/.ssh/.
```

* * *

## Linux "clients"

#### pushing LFS projects to git server

- if this is not yet set...

```sh
git remote add origin git@gitbox.internal:studio_wide_group/lfs-test.git
```

- **NOTE**: LFS uses http(s) for everything: authentication, obtain the URL of the LFS file, and GET/PUT the LFS file

```sh
git config --add lfs.url "http://gitbox.internal/group/project.git/info/lfs"
```

- credential caching **MUST** be used (especially when pushing/pulling more than 1 LFS file)

```sh
git config --global credential.helper 'cache --timeout=3600'
```

- finally

```sh
git push -u origin master
```

###### notes about: project.git/info/lfs --&gt; [info/lfs] --&gt; i.e. _lfs.url_

- <http://doc.gitlab.com/ce/workflow/lfs/manage_large_binaries_with_git_lfs.html>
	- mentions if: `lfs.batch = false`, is in: `.../project/.git/config`, to remove it

```sh
git config --unset lfs.batch
```

- <https://gitlab.citius.usc.es/help/workflow/lfs/manage_large_binaries_with_git_lfs.md>
- <https://github.com/github/git-lfs/blob/master/docs/api/README.md>

#### CLONING

```sh
git clone git@gitbox.internal:group/project.git
	# this will return error messages...
	# but !!! **need to add lfs.url first** !!!

cd project
git config --add lfs.url "http://gitbox.internal/group/project.git/info/lfs"
git checkout -f HEAD
```

* * *

## note to self...

#### misc - todo - to investigate - etc.

- it seems that `/var/opt/gitlab/git-data/lfs-objects` will store ALL LFS objects...
- meaning, they are mixed in with all of the projects...
- need to see if there's an easy way to extract all objects by projects...

- to redo everything (e.g. testing replication steps):
	- **WARNING**: this will NUKE existing GitLab

```sh
sudo gitlab-ctl cleanse
sudo apt-get install --reinstall gitlab-ce
```

* * *

## Windows "clients"

#### WINDOWS (client) instructions

- open browser to (internal) gitlab page: `http://gitbox.internal`
- make an account for yourself
- check your email for verification link

- download windows installer for git and git-lfs
	- <https://git-scm.com/download/win>
	- <https://git-lfs.github.com/>

- right click any folder -&gt; select "Git Bash"

- make "Git Bash" LFS aware

```sh
git lfs install
```

- jic

```sh
git config --global user.name "First Last"
git config --global user.email "username@domainname.tld"
git config --global credential.helper 'cache --timeout=3600'
```

- !!! **MUST DO** !!!

```sh
git config --global credential.helper wincred
```

- **WARNING**: on windows -- ssh key file **MUST be id_rsa &amp; id_rsa.pub**

```sh
ssh-keygen -t rsa -C "username@gitbox.internal"
cat id_rsa.pub
# copy output to gitlab webpage [ profile settings -> ssh keys -> +add ssh key -> key ]
mv id_rsa* ~/.ssh/.
```

#### for each new project

- **MUST clone via GIT BASH** (but can use any git GUI client after these steps)

- fire up the ssh private/public key handler -- called the "agent"

```sh
eval "$(ssh-agent -s)"
```
	- then follow [CLONING](#CLONING) steps

- if errors here, might need to add hostname to `c:\windows\system32\drivers\etc\hosts`

#### finally

- fire up your favorite git client and add this project
- github's desktop client looks pretty easy/simple
- atlassian's sourcetree also looks good

* * *

