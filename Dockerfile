FROM alpine:latest


RUN \
    apk update && \
    apk --update add bash curl bind-tools jq mysql-client postgresql-client git lynx && \
    rm -rf /var/cache/apk/*


RUN \
    mkdir -p /aws && \
    apk -Uuv add groff less python py-pip gnupg && \
    pip install awscli && \
    apk --purge -v del py-pip && \
    rm /var/cache/apk/*


RUN \
    apk update && \
    apk fetch openjdk8 && \
    apk add openjdk8 && \
    apk add --no-cache nss && \
    rm /var/cache/apk/*

RUN adduser -u 1111 -S user

ENV JAVA_HOME /usr/lib/jvm/default-jvm

#Unpack all files in apps
ADD apps/* /home/user/

#set owner for unpacked files (this might be slow)
#Note: --chown on ADD works only on archive itself
RUN chown -R 1111 /home/user/

WORKDIR /home/user

USER 1111

CMD ["/bin/sh"]
