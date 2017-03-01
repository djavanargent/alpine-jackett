FROM lsiobase/alpine:3.5
MAINTAINER djavanargent

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:-${VERSION} Build-Date:-${BUILD_DATE}"

# environment settings
ENV XDG_DATA_HOME="/config" \
    XDG_CONFIG_HOME="/config"

# Install packages
RUN \
  apk add --no-cache \
    curl \
    libcurl \
    python2 \
    tar \
    wget && \
  apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
    mono && \

# Install jackett
  mkdir -p /app/Jackett && \
  jack_tag=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
  curl -o /tmp/jacket.tar.gz -L https://github.com/Jackett/Jackett/releases/download/$jack_tag/Jackett.Binaries.Mono.tar.gz && \
  tar zxf /tmp/jacket.tar.gz -C /app/Jackett --strip-components=1 && \

# cleanup
  rm -rf /tmp/*

# add local files
COPY root /

# ports and volumes
VOLUME /config /downloads
EXPOSE 9117
