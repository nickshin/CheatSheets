<style>
.note1                    { font-size: 11px; }
pre                       { margin-left: 2em; }
.markdown-body pre code   { font-size: 80%; }
.blink                    { text-decoration: blink; }
</style>

# Docker.IO

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>

* * *

## First things first

- Note: do not confuse this and the "docker" package which is a "System tray for KDE3/GNOME2 docklet applications"
```sh
sudo apt-get install docker.io
sudo ln -s /usr/bin/docker.io /usr/bin/docker
```

- Add yourself to the **docker group** so you **don't**
need to run docker with **sudo**:
```sh
sudo usermod -a -G docker <username>
```

- AND! logout of your (X)session and back in; to have your **groups** updated

* * *

## HowTos

- [Docker Interactive Tutorial](https://www.docker.com/tryit/) - training wheels
- [Docker Basics](https://docs.docker.com/articles/basics/) - crash course: using Docker
- [Dockerfile Reference](https://docs.docker.com/reference/builder/) - crash course: making a Docker Image
<br>&nbsp;
- [Docker Cheatsheet](https://github.com/wsargent/docker-cheat-sheet) - good overview
- [The Docker User Guide](http://docs.docker.com/userguide/)
	- Docker's online documentation is quite thorough.
	- But also **very easy** to walk through each section.
	- Going through the **whole** User Guide is HIGHLY RECOMMENDED and simple to follow.
<br>&nbsp;
- [Docker Clean Up](http://blog.stefanxo.com/2014/02/clean-up-after-docker/)


## Tips

- [CMD vs ENTRYPOINT](http://stackoverflow.com/questions/21553353/what-is-the-difference-between-cmd-and-entrypoint-in-a-dockerfile)
	- But, you can override [ENTRYPOINT] with:
```sh
docker --entrypoint=<some cmd to run> ...
```

	- Note: you can only run one container when using [ENTRYPOINT]
		- see ["Start the container (again)"](#rm_entrypoint) below for details
<br>&nbsp;
	- Note: you can run the [CMD] image ~~over and over~~ again and again
		because a new container is created for each run.
<br>&nbsp;
	- And, you can combo [ENTRYPOINT] with [CMD] to give the entrypoint a default set
		of options (via [CMD]) if no arguments were passed in with the command
		- i.e. [ENTRYPOINT] + ( args \|\| [CMD] )
		- see [Docker Best Practices](http://crosbymichael.com/dockerfile-best-practices.html)
			-- section "5. CMD and ENTRYPOINT better together" for more details on this
<br>&nbsp;
- A **tagName** should look like:
	- repository/username/project
		- e.g.: host.domain.tld/username/project
		- e.g.: IP_address/username/project
		- e.g.: 127.0.0.1:5000/username/project
	- When using a ["private" registry](http://blog.docker.com/2013/07/how-to-use-your-own-registry/),
		do not do: `my_repo/username/project`
		- docker will assume `my_repo` is a username and look for it in the official repository
<br>&nbsp;
- [Docker Volumes](https://docs.docker.com/userguide/dockervolumes/)

```sh
# ----------------------------------------
# Mount a directory from host to a container:

docker run -v /host/path:/docker/path <imageID>
docker run -v /host/path:/docker/path <tagName>

# docker help run
# -v, --volume=[]    : Bind mount a volume \(e.g. from the host: -v /host:/container, from docker: -v /container\)
# --volumes-from=[]  : Mount volumes from the specified container\(s\)


# ----------------------------------------
# Mount a directory from a container to another container:

# "same" container
docker run -v /docker/path_a -v /docker/path_b --name <containerName_1> <imageID_1>
docker run -v /docker/path_a -v /docker/path_b --name <containerName_1> <tagname_1>

	# the following also does the same in Dockerfile:
	# VOLUME ["/docker/path_a", "/docker/path_b"]


# multiple contianers
docker run --volumes-from <containerName_1> --name <containerName_2> <imageID_2>
docker run --volumes-from <containerName_1> --name <containerName_2> <tagName_2>

# and, can be chained
docker run --volumes-from <containerName_2> --name <containerName_3> <imageID_3>
docker run --volumes-from <containerName_2> --name <containerName_3> <tagName_3>
```

- [Linking Containers Together](http://docs.docker.com/userguide/dockerlinks/)

```sh
docker run -d    --name <containerName_1>                                    <imageID_1>
docker run -d -P --name <containerName_2> --link <containerName_1>:<alias_1> <imageID_2>
# OR
docker run -d    --name <containerName_1>                                    <tagName_1>
docker run -d -P --name <containerName_2> --link <containerName_1>:<alias_1> <tagName_2>

# docker help run
# --link=[]  : Add link to another container (name:alias)
# --name=""  : **Assign a name to the container**


# note: inside of <containerName_2>, the environment variables <alias_1>_* are connection information from <containerName_1>
```

- [ADD](https://docs.docker.com/reference/builder/#add) vs [COPY](https://docs.docker.com/reference/builder/#copy)
	- ADD is just like COPY -- with the following caveats:
		- NOTE: both CANNOT (due to context directory sent to the docker daemon):
			- COPY ../src_something /dst_something
			- ADD  ../src_something /dst_something
		- NOTE: also, both CANNOT (due to no build directory):
			- build STDIN from LOCAL SRC
			- BUT! (STDIN) ADD allows SRC as URL
<br>&nbsp;
	- ADD also does (where COPY does not)
		- SRC as an archive (e.g. tar.gz, bz2, xz)
		- SRC as URL (but, if requires authentication -- need to use RUN wget or RUN curl)
			- NOTE: DST will have permissions set to 600
<br>&nbsp;
- [SAVE vs EXPORT](http://tuhrig.de/flatten-a-docker-container-or-image/)
	- docker can be **saved** (images) or **exported** (container)
	- both of these can be dumped to (as well as loaded from) a TAR file
		(see link above for details)
<br>&nbsp;
	- however, it is also possible to poke around directly in the docker cache `/var/lib/docker`
<br>&nbsp;
		- just in case this is not obvious: <br>
			<span class='Xblink'>
			!!! WARNING !!! <br>
			!!! OFFER NOT VALID !!! <br>
			!!! WARRARNTY VOID !!! <br>
			!!! USE AT YOUR OWN RISK !!! <br>
			!!! NYAN CAT !!! </span>
<br>&nbsp;
		- while containers are running:
```sh
./aufs/mnt/<containerID>/...
./containers/<containerID>/root/...
```

		- otherwise, you might also be able to look around in:
```sh
./aufs/diff/<containerID>/...
./aufs/diff/<imageID>/...
```

		- Remember, it may be best to use [Docker Volumes](#docker_volumes) to persist any files on the host.
		- But, just in case you want to see more about this: see
			[Advanced Docker Volumes](http://crosbymichael.com/advanced-docker-volumes.html):
			**Under the Hood** where it uses the **docker inspect** command

* * *

## Snippets

### Build an image

- The long way:

```sh
docker build .
# this returns an **imageID**

docker tag <imageID> <tagName>
```

- The short way:

```sh
docker build -t <tagName> .
```

### Start an image

This will create a "running" **container**.
This is basically a running snapshot of the image.
```sh
docker run <imageID>
docker run <imageID> --name <containerName>
docker run <tagName>
docker run <tagName> --name <containerName>
docker run -i -t <imageID>
docker run -i -t <imageID> --name <containerName>
docker run -i -t <tagName>
docker run -i -t <tagName> --name <containerName>

# docker help run
# -i : Keep stdin open even if not attached
# -t : Allocate a pseudo-tty
```

- These all will return the **containerID**.

### Stop the container

```sh
docker stop <containerID>
docker stop <containerName>
```

- If running with tty interface, CTRL+C or exit your CMD

- Note: if image was run with --rm, the contain will be removed automatically on exit
```sh
# docker help run
# --rm=false: Automatically remove the container when it exits (incompatible with -d)
```

- And yes, this will lose any run time created files in the container upon exiting...
	- Again, use [Docker Volumes](#docker_volumes) to persist any files on the host.

After terminating the run, the **container** (a snapshot of your run) can be either:
- UPDATE the image
```sh
docker commit <containerID>
docker commit <containerID> <imageID>
docker commit <containerID> <tagName>
docker commit <containerID> <newTagName>
docker commit <containerName>
docker commit <containerName> <imageID>
docker commit <containerName> <tagName>
docker commit <containerName> <newTagName>
```

- <a name='rm_entrypoint'> REMOVED </a> so a new image run [ENTRYPOINT] can be done again
```sh
docker rm <containerID>
docker rm <containerName>
```

### Start the container (again)

```sh
docker start <containerID>
docker start <containerName>
```

### Start over

- Stop all relevant containters, nuke them and then nuke the image.

```sh
docker stop <containerID>
docker rm <containerID>
docker rmi <imageID>

docker stop <containerName>
docker rm <containerName>
docker rmi <imageID>
```

- Docker will complain enough to find the IDs/Names that are "still-in-use".

* * *

## Registry

- fetch, build and run local (private) registry using docker itself:
```sh
docker run -p 5000:5000 registry
```

- push an image
```sh
docker push <imageID>
docker push <tagName>
```

- now, **http://localhost:5000/v1/search** will show something interesting...
<br>&nbsp;
- for more details:
	- [docker-registry](https://github.com/docker/docker-registry) @ github
	- [Docker Registry](http://blog.octo.com/en/docker-registry-first-steps/)

* * *

## External Resoures

### Example Dockerfiles
- [Create lightweight Docker containers with Buildroot](http://blog.docker.com/2013/06/create-light-weight-docker-containers-buildroot/)
- [Installing Redis on Docker](http://blog.docker.com/2013/04/installing-redis-on-docker/)
- And a lot more at: [docs.docker.com/examples/](http://docs.docker.com/examples/#examples)

### DockerCon 2014
- [DockerCon Video: be a Happier Developer with Docker](http://blog.docker.com/2014/06/dockercon-video-be-a-happier-developer-with-docker/)
- [DockerCon video: Cluster Management and Containerization at Twitter](http://blog.docker.com/2014/06/dockercon-video-cluster-management-and-containerization-at-twitter/)

* * *

