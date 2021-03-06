# docker-node-autoupdater

Base node image created because I was tired of rebuilding node image all the time. What it does? 

Basically, it performs quick check before every container command if any new package appeared, and if yes, installs it. Thanks to this, we don't have to reinstall all packages after every change (as with `docker build`). Volume is required to work properly.

You can use any of the following versions:
    
    # based on node
    valian/docker-node-autoinstaller, valian/docker-node-autoinstaller:latest
    
    # based on node:alpine
    valian/docker-node-autoinstaller:alpine


## Usage

Add to your `.gitignore` file `.package.json.hash`:

```bash
echo ".package.json.hash" >> .gitignore
```   


Now you can run docker container, or use it as a base for your image

```bash

cd /path/to/your/project/with/package.json

# instead of npm run dev, you can pass any command you want
# you local directory will be mounted under /srv inside container
# and after each run, package.json will be checked for updates

docker run --rm \
  -v $PWD:/srv \
  valian/docker-node-autoinstaller \
  npm run dev

# there are a couple of utility commands, too:
# clean - clears node_modules directory

docker run --rm \
  -v $PWD:/srv \
  valian/docker-node-autoinstaller \
  clean

# force-install - unconditionally reinstalls packages

docker run --rm \
  -v $PWD:/srv \
  valian/docker-node-autoinstaller \
  force-install

# install - adds package as dev-dependency and installs it

docker run --rm \
  -v $PWD:/srv \
  valian/docker-node-autoinstaller \
  install react
```

You can also extend this image in the same way as a normal node image.

## Docker-compose

Example `docker-compose.yml` for convenient usage:

```yaml
version: '2'

services:
  node:
    image: valian/docker-node-autoinstaller
    command: npm run dev
    ports:
      - 3000:3000
    volumes:
      - .:/srv

```

Copy it to your project root and now you can start project with 'docker-compose up'
