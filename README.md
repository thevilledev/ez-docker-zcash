# docker-zcash

Docker configuration for building & running Zcash node & client in Docker.

Requires multi-stage support from Docker, so version >= 17.05 is required.

# Building your own image

Clone this repository:

```
$ git clone https://github.com/vtorhonen/docker-zcash.git
$ cd docker-zcash
$ sudo docker build -t docker-zcash .
```
It takes quite a while to build the app. Grab a beer or two while waiting.

# Using pre-built images

If you trust me (note: you shouldn't) you can use pre-built images from my Dockerhub.

```
$ sudo docker pull vtorhonen/docker-zcash:1.0.10-1
```

Image size is about size is about 330 MB
My suggestion is that you build your own images.

# Running a Zcash node

This container uses `/zcash/data` as data directory for Zcash. Needless to say, you should use some sort of persistent storage.

Run the following command to run a Zcash node by using local volume mounts in interactive mode:

```
$ mkdir data
$ sudo docker run --name my-zcash -ditv $(pwd)/data:/zcash/data vtorhonen/docker-zcash -datadir=/zcash/data
```
If you want to attach to the process to see where blockchaing sync is at you can run:

```
$ sudo docker attach my-zcash
```

Use `^C-p-^C-q` to detach. Do not use `^C-c` or you will exit the shell and kill your node.


# Running Zcash CLI (your wallet)

You can interact with your wallet by using `zcash-cli` as follows:

```
$ docker exec -ti my-zcash zcash-cli -datadir=/zcash/data getbalance
0.00000000
```

# Backing up your wallet

Your data directory is super important. Take backups by following [instructions from Zcash documentation](https://github.com/zcash/zcash/blob/master/doc/wallet-backup.md).

