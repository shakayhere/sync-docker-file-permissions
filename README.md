# Configurations for Synchronizing File Permissions in Docker
The configurations in this repository creates a user and a group inside of the Docker container with the same IDs we are using locally. When this is done, file permissions are synchronized, because the same user and group is used.

## How to start
First we have to export our user and group ID in our shell environment. in `~/.zshrc` or `~/.bashrc`, add the following to export user and group ID's:

```
# Exporting user and group ID as variables for Docker and Docker Compose
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
```
## Configuring Dockerfile
After configuring our variables, we can use the configurations from Dockerfile to create a user with the same ID as our local machine:

```
# Setting base image
FROM golang:1.16

# Building arguments for user and group ID
ARG USER_ID
ARG GROUP_ID

# Setting environment variables for docker environment
ENV USER_ID=$USER_ID
ENV GROUP_ID=$GROUP_ID
ENV USER_ID=${USER_ID:-1001}
ENV GROUP_ID=${GROUP_ID:-1001}

# Adding group and user based on build arguments
RUN addgroup --gid ${GROUP_ID} appdev
RUN adduser --disabled-password --gecos '' --uid ${USER_ID} --gid ${GROUP_ID} appdev

# Setting user and group of working directory
RUN chown -R appdev:appdev /app

# Setting active user in docker
USER appdev
```

## Configuring docker-compose.yml
For docker-compose, we will use the following configuration to pass user and group ID:

```
version: '3.3'

networks:
  web:
    external: true

services:
  application:
    container_name: application
    build:
      context: .
      dockerfile: ./Dockerfile
      args:
      # Passing user and group ID as arguments
        USER_ID: $USER_ID
        GROUP_ID: $GROUP_ID
    networks:
      - web
    volumes:
      - ./:/app      
    restart: always
```

## License
Copyright (c) 2022 shakayhere

Permission is hereby granted, free of charge, to any person obtaining a copy of this code, to deal in any Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software.
