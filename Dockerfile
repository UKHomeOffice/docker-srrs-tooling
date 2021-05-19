FROM alpine:latest

#install tools
RUN \
    apk update && \
    apk --update add bash curl bind-tools jq mysql-client postgresql-client git lynx openssh nano && \
    rm -rf /var/cache/apk/*

#install AWS cli
RUN \
	mkdir -p /aws && \
	apk -Uuv add groff less python3 py-pip gnupg && \
	pip install awscli && \
	rm -rf /var/cache/apk/*

#install Java
RUN \
    apk update && \
    apk fetch openjdk8 && \
    apk add openjdk8 && \
    apk add --no-cache nss && \
    rm -rf /var/cache/apk/*


RUN adduser -u 1111 -S user

#setup JAVA_HOME (for jmeter)
ENV JAVA_HOME /usr/lib/jvm/default-jvm

#Unpack all files in apps
ADD apps/* /home/user/

#set owner for unpacked files (this might be slow)
#Note: --chown on ADD works only on archive itself
RUN chown -R 1111 /home/user/

WORKDIR /home/user

USER 1111

CMD ["/bin/sh"]
