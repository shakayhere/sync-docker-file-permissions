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