FROM ubuntu:18.04

RUN apt -qq update

ENV TZ Asia/Kolkata

RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    ffmpeg mediainfo rclone
RUN apt-get install -y software-properties-common

RUN apt -qq update
RUN mkdir AAC
RUN cd AAC/
RUN curl http://ftp6.nero.com/tools/NeroAACCodec-1.5.1.zip
RUN unzip -j NeroAACCodec-1.5.1.zip
RUN sudo install -m 0755 neroAacEnc /usr/bin/
RUN sudo apt-get install gpac

RUN cd ..

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python3", "-m", "termbot"]
