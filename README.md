# ez-docker-zcash

This just might be the easiest way to get a Zcash node/wallet running!

Includes Docker configuration for building & running Zcash node in Docker. No need to install any extra build tools into your OS.

The zk-SNARK proofs are baked into the image rather than shared through a volume. This suits very well for those who just want a single Zcash wallet running as fast as possible.

# Prequisites

Build requires multi-stage support from Docker, so version >= 17.05 is required.

Install `docker-compose` if you want to use it to set up your node. Useful for all the lazy people.

# Building

First clone this repository:

```
$ git clone https://github.com/vtorhonen/ez-docker-zcash.git
$ cd ez-docker-zcash
```

Use `docker-compose` if you want things blazing fast.

```
$ sudo docker-compose build
$ sudo docker-compose up -d
```

Build with `docker build`:

```
$ sudo docker build -t my-docker-zcash .
```

It takes quite a while to build the app. Grab a beer or two while waiting.

# Using pre-built images

If you trust me (note: you shouldn't) you can use pre-built images from my Dockerhub: https://hub.docker.com/r/vtorhonen/ez-docker-zcash/

This is obviously the fastest way. Just start the node with `docker-compose`:

```
$ sudo docker-compose up -d
```

This downloads the image from Dockerhub and starts the container. Compressed image size is about about 990 MB.

Data directory called `data` is created to the working directory upon startup. It is then mounted to the container by default. You won't lose your wallet if you destroy the container.

Since Dockerhub doesn't support multi-stage builds yet (see issue [#1](https://github.com/vtorhonen/ez-docker-zcash/issues/1)) the builds are probably not as transparent as they should be. Will be fixed.

# Accessing your wallet

You can interact with your wallet by using `zcash-cli.sh` wrapper script. Note that blockchain syncing takes 4-5 hours to complete after container startup and it is wise to wait.

Check current sync status:

```
$ ./zcash-cli.sh getinfo
```

Run it a couple of times to see if the value of `blocks` is changing.

Check your wallet balance:

```
$ ./zcash-cli.sh getbalance
0.00000000
```

Generate new Z-type address:

```
$ ./zcash-cli.sh z_getnewaddress
zcTQgjnCDsmgSK64EACpsJy3QoQSpaCP8NbDeCF8xTyG5q5KFujjdaDSKVDcs2JtDpN7vCFL9rEPPY4tETYHZtt5iasYkjo
```

Run `./zcash-cli.sh help` to get full command reference.

# Running a Zcash node manually

This container uses `/zcash/data` by default as the data directory for Zcash. Needless to say, you should use some sort of persistent storage to store the blockchain and your wallet.

Container supports the following environment variables for configuration:

| Environment variable | Default value | Description |
-----------------------|---------------|--------------
`ZCASH_RPCUSER`     | 32 char long random string | Username for RPC access. Randomized on startup, if not set.
`ZCASH_RPCPASSWORD` | 32 char long random string | Password for RPC access. Randomized on startup, if not set.
`ZCASH_ADDNODE`     | `mainnet.z.cash` | Target network. Uses zcash main network by default.
`ZCASH_DATADIR`     | `/zcash/data`| Data directory for storing blockchain and wallet.

Run the following command to run a Zcash node by using local volume mounts in interactive mode:

```
$ mkdir data
$ sudo docker run \
	--name zcash-node -dit \
	-v $(pwd)/data:/zcash/data \
	vtorhonen/ez-docker-zcash
```
If you want to attach to the process to see where blockchaing sync is at you can run:

```
$ sudo docker attach zcash-node
```

Use `^C-p-^C-q` to detach. Do not use `^C-c` or you will exit the shell and kill your node.

You can also use the wrapper script by defining a custom `CONTAINER_NAME` environment variable.

```
$ export CONTAINER_NAME="zcash-node"
$ ./zcash-cli.sh getbalance
0.00000000
```

# Backing up your wallet

Your data directory is super important. Take backups by following [instructions from Zcash documentation](https://github.com/zcash/zcash/blob/master/doc/wallet-backup.md).

# Feedback

Feedback is more than welcome! If you have any questions, feedback or improvements just create a Github issue.
