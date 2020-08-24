FROM ubuntu:18.04


RUN apt -qq update

ENV TZ Asia/Kolkata

RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    ffmpeg mediainfo rclone
RUN apt-get install -y software-properties-common

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

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python3", "-m", "termbot"]
