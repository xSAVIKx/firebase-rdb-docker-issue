FROM node:lts-alpine3.12 AS app-env

LABEL "maintainer"="Yuri.Sergiichuk@teamdev.com" \
      "emulator"="Firebase RDB"

RUN apk add openjdk11-jre && \
    npm install -g firebase-tools && \
    firebase setup:emulators:database && \
    rm -rf /var/cache/apk/*

COPY ./firebase-docker.json /firebase.json

ENTRYPOINT [ "firebase", "emulators:start", "--debug" ]
