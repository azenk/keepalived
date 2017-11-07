FROM alpine:latest
ENV KEEPALIVED_VERSION "1.3.9"
WORKDIR /usr/local/src/
ADD http://www.keepalived.org/software/keepalived-$KEEPALIVED_VERSION.tar.gz .
RUN tar -zxf keepalived-$KEEPALIVED_VERSION.tar.gz
WORKDIR /usr/local/src/keepalived-$KEEPALIVED_VERSION
RUN apk add --no-cache gcc musl-dev linux-headers openssl-dev libnl3-dev libnfnetlink-dev make
RUN ./configure --prefix=/opt/keepalived && make && make install

FROM alpine:latest
RUN apk add --no-cache openssl libnl3 libnfnetlink
COPY --from=0 /opt/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/
COPY --from=0 /opt/keepalived/bin /usr/bin
COPY --from=0 /opt/keepalived/sbin /usr/sbin
CMD ["/usr/sbin/keepalived", "-nl"]
