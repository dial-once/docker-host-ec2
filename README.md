# docker-host-ec2
Run update commands on host node (debian/ubuntu) and update network driver + some tweaks. Meant to be used with docker cloud.

This containers add its own RSA key to host machine, run update commands, and then remove its RSA key.
It needs network mode set to host and a shared volume on host .ssh folder.

## Usage

```bash
docker run -v /root/.ssh/authorized_keys:/data/authorized_keys:rw --net=host dialonce/host-update:latest
```

## Docker Cloud

```yml
host-ec2:
  autodestroy: always
  image: 'dialonce/host-ec2:latest'
  net: host
  deployment_strategy: every_node
  volumes:
    - '/root/.ssh/authorized_keys:/data/authorized_keys'
```

## Env vars

You can customize the host name by setting the `HOST_USR` env var. Default is `root`
