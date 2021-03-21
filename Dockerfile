FROM ubuntu:latest

VOLUME ["/starbound", "/starbound_upgrade"]

ENV FORCE_UPGRADE = 0

COPY start.sh /start.sh

RUN apt-get update \
	&& apt-get install -y unzip \
	&& mkdir -p /starbound \
	&& mkdir -p /starbound_upgrade \
	&& chmod a+x start.sh

EXPOSE 21025/tcp
EXPOSE 21026/tcp

CMD /start.sh
