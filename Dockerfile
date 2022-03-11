FROM ubuntu:20.04

MAINTAINER vitams "vmpartner@gmail.com"

RUN apt-get update && \
    apt-get install -y exim4-daemon-light iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    find /var/log -type f | while read f; do echo -ne '' > $f; done;

COPY entrypoint.sh /bin/
COPY set-exim4-update-conf /bin/

RUN chmod a+x /bin/entrypoint.sh && \
    chmod a+x /bin/set-exim4-update-conf

ADD dkim/config /etc/exim4/_docker_additional_macros
ADD dkim/privatekey.txt /etc/exim4/domain.key

EXPOSE 25
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["exim", "-bd", "-q15m", "-v"]
