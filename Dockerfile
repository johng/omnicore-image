FROM ubuntu:latest as builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install make git gcc g++ wget autoconf libtool pkg-config libdb++-dev libboost-all-dev bsdmainutils libssl-dev

WORKDIR /root/workdir

RUN git clone https://github.com/OmniLayer/omnicore.git && cd omnicore && git checkout v0.9.0
RUN cd omnicore && ./autogen.sh && ./configure --with-incompatible-bdb && make
RUN cd omnicore && make install

FROM ubuntu:latest 

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install libboost-all-dev libdb++-dev 
COPY --from=builder /usr/local/bin/omnicored /usr/local/bin/omnicored

COPY entrypoint.sh /root/entrypoint.sh


EXPOSE 18444
EXPOSE 18330
ENTRYPOINT /root/entrypoint.sh
