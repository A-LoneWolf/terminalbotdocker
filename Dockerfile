FROM ubuntu:18.04


RUN apt -qq update

ENV TZ Asia/Kolkata

FROM ubuntu:16.04

# Container for compiling ffmpeg and copying ffmpeg, ffprobe, and ffserver to the host operating system.
# If the host OS is not linux, another container could instead use the binary.

# Example build
# docker build -t ffmpeg-compiler .

# Example run
# docker run --rm -it -v $(pwd):/host ffmpeg-compiler bash -c "cp /root/bin/ffmpeg /root/bin/ffprobe /root/bin/ffserver /host && chown $(id -u):$(id -g) /host/ffmpeg && chown $(id -u):$(id -g) /host/ffprobe && chown $(id -u):$(id -g) /host/ffserver"

MAINTAINER srwareham

# Get the dependencies
RUN set -x \
&& apt-get update \
&& apt-get -y install wget curl autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev \
&& mkdir ~/ffmpeg_sources \
&& apt-get -y install yasm \
&& cd ~/ffmpeg_sources \
&& wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz \
&& tar xzvf yasm-1.3.0.tar.gz \
&& cd yasm-1.3.0 \
&& ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" \
&& make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
&& make install \
&& make distclean \
&& apt-get -y install libx264-dev \
&& apt-get -y install cmake mercurial \
&& echo COMPLETED PART 1

RUN set -x \
&& cd ~/ffmpeg_sources \
&& hg --version \
&& hg clone https://bitbucket.org/multicoreware/x265 \
&& cd ~/ffmpeg_sources/x265/build/linux \
&& PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source \
&& make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
&& make install \
&& make clean \
&& cd ~/ffmpeg_sources \
&& wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master \
&& tar xzvf fdk-aac.tar.gz \
&& cd mstorsjo-fdk-aac* \
&& autoreconf -fiv \
&& ./configure --prefix="$HOME/ffmpeg_build" --disable-shared \
&& make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
&& make install \
&& make distclean \
&& echo COMPLETED PART 2

RUN set -x \
&& echo install libmp3lame \
&& apt-get -y install libmp3lame-dev \
&& apt-get -y install libopus-dev \
&& cd ~/ffmpeg_sources \
&& wget https://github.com/webmproject/libvpx/archive/v1.8.2.tar.gz \
&& tar xzvf v1.8.2.tar.gz \
&& cd libvpx-1.8.2 \
&& PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests \
&& PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
&& make install \
&& make clean

#install ffmpeg
RUN cd ~/ffmpeg_sources \
&& wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 \
&& tar xjvf ffmpeg-snapshot.tar.bz2 \
&& cd ffmpeg \
&& PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-libs=-static \
  --extra-cflags=--static \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
&& PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
&& make install \
&& make distclean \
&& hash -r

RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    ffmpeg mediainfo rclone
RUN apt-get install -y software-properties-common

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

FROM python:3-stretch
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get -y install postgresql-client git wget gosu autoconf automake build-essential cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev libsamplerate-dev libspeex-dev libtheora-dev libtool libtool-bin libvorbis-dev libx264-dev libxml2-dev libvpx-dev m4 make patch pkg-config python tar yasm zlib1g-dev && \
    wget -O /var/cache/apt/archives/nasm.deb 'http://ftp.fi.debian.org/debian/pool/main/n/nasm/nasm_2.14-1_amd64.deb' && \
    dpkg -i /var/cache/apt/archives/nasm.deb && \
    apt-get install -y libva-dev libdrm-dev && \
    git clone https://github.com/HandBrake/HandBrake.git && \
    cd HandBrake && \
    ./configure --launch-jobs=$(nproc) --launch --disable-gtk && \
    make --directory=build install && \
    rm -rf build


CMD ["python3", "-m", "termbot"]
