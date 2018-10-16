FROM node:8.12-slim as builder

RUN apt-get update -yy && \
    apt-get install -yy \
     build-essential libavahi-compat-libdnssd-dev python git

COPY . /multicast
RUN cd /multicast && npm install --only=dev && npm install --only=prod
RUN cd /multicast && ./node_modules/.bin/gulp


FROM node:8.12-slim

RUN groupadd -g 996 multicast && \
    useradd -r -u 996 -g multicast multicast

RUN apt-get update -yy && \
    apt-get install -yy \
        avahi-daemon avahi-discover avahi-utils libnss-mdns \
        iputils-ping dnsutils libavahi-compat-libdnssd-dev

COPY ./docker/multicast/avahi-daemon.conf /etc/avahi/avahi-daemon.conf

COPY ./docker/multicast/start.sh /
RUN chmod +x /start.sh

COPY ./docker/multicast/wait-for-it.sh /
RUN chmod +x /wait-for-it.sh

COPY --from=builder /multicast /multicast

CMD /start.sh
