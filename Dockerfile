FROM python:3-slim-bullseye
LABEL maintainer synoniem https://github.com/synoniem

# Set environment variables.
ENV TERM=xterm-color
ENV SHELL=/bin/bash
# Use a shell script to select the right s6-overlay installer for the processor architecture
WORKDIR /
COPY ./build_internal.sh /build_internal.sh
COPY etc/cont-init.d /etc/cont-init.d
COPY etc/fix-attrs.d /etc/fix-attrs.d
COPY etc/services.d /etc/services.d
COPY certbot.sh /certbot.sh
COPY restart.sh /restart.sh

# Choose needed packages.
RUN \
	mkdir /mosquitto && \
	mkdir /mosquitto/log && \
	mkdir /mosquitto/conf && \
	apt-get update && \
	apt-get upgrade && \
	apt-get install -y --no-install-recommends \
		bash \
		cron \
		coreutils \
		nano \
        vim \
		curl \
		wget \
        python3-cryptography \
		ca-certificates \
        certbot \
		mosquitto \
		mosquitto-clients && \
		apt-get autoremove -y && \
		rm -rf /var/lib/lists/* && \
		rm -rf /etc/cron.*/*

COPY etc/mosquitto /etc/mosquitto
COPY etc/crontab /etc/crontab
COPY croncert /etc/cron.weekly/croncert
RUN	/build_internal.sh && \
    rm /build_internal.sh && \
	pip install --upgrade pip && \
	pip install pyRFC3339 configobj ConfigArgParse
RUN chmod +x /certbot.sh && \
	chmod +x /restart.sh && \
	chmod +x /etc/cron.weekly/croncert

ENTRYPOINT ["/init"]
