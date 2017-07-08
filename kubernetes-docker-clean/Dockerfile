FROM alpine:3.6

RUN apk add --update bash docker \
    && rm -rf /var/cache/apk/*

COPY docker-clean.sh /bin/docker-clean.sh
RUN chmod +x /bin/docker-clean.sh

COPY cron/root /var/spool/cron/crontabs/root

CMD crond -l 2 -f
