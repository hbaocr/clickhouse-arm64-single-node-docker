FROM ubuntu:20.04 as builder
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Moscow


RUN apt-get update
RUN apt-get install -y  gnutls-bin clang-11 wget curl git cmake python3 ninja-build build-essential tzdata lsb-release software-properties-common

ENV CC clang-11
ENV CXX clang++-11
RUN mkdir -p src 
WORKDIR /src
RUN git clone --recursive https://github.com/ClickHouse/ClickHouse.git
RUN mkdir -p build
WORKDIR /src/build
RUN cmake ../ClickHouse
RUN ninja

FROM ubuntu:20.04 as runner
RUN apt-get update
#ENV DEBIAN_FRONTEND noninteractive
ENV TZ UTC
#RUN apt-get install -y  locales gnutls-bin build-essential tzdata lsb-release software-properties-common
RUN apt-get install -y  locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# https://clickhouse.tech/docs/en/development/developer-instruction/
# Copy execuatable binaries from builder to runner to make it run
COPY --from=builder /src/build/programs /usr/bin/
#https://github.com/ClickHouse/ClickHouse/tree/master/docker/server


EXPOSE 9000 8123 9009

#can be overide when run this container with external cmd
CMD ["clickhouse-server","start"]
#VOLUME /var/lib/clickhouse
