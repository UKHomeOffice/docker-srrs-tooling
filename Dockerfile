FROM alpine:latest


RUN \
    apk --update add bash curl bind-tools jq mysql-client git && \
    rm -rf /var/cache/apk/*


RUN \
	mkdir -p /aws && \
	apk -Uuv add groff less python py-pip gnupg && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

RUN adduser -u 1111 -S user

WORKDIR /home/user

USER 1111

CMD ["/bin/sh"]