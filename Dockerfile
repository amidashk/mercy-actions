# FROM node:22.9
FROM node:22.8

ARG DOCKER_USER=app
ARG DOCKER_UID=1001
ARG DOCKER_WORKDIR=/usr/src/app
ARG EXPOSE_PORT=8080

# RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN useradd -s /sbin/nologin -d $DOCKER_WORKDIR -u $DOCKER_UID $DOCKER_USER
USER $DOCKER_USER
WORKDIR $DOCKER_WORKDIR

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY --chown=$DOCKER_USER:$DOCKER_USER src/package*.json .

RUN npm install

# Bundle app source
COPY src .

EXPOSE $EXPOSE_PORT
CMD [ "node", "server.js" ]
HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --retries=3 \
    CMD curl -f http://localhost:$EXPOSE_PORT/ || exit 1
