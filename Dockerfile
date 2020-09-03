FROM jrottenberg/ffmpeg:latest as xyz

FROM ubuntu:18.04

RUN mkdir -p /usr/local
WORKDIR /usr/local/
COPY --from=xyz /usr/local . 
RUN ln -s /opt/ffmpeg/share/model /usr/local/share/
RUN ldconfig
ENV PATH="/opt/ffmpeg/bin:$PATH"

WORKDIR     /app
RUN apt -qq update
RUN apt -qq install -y curl git gnupg2 wget nodejs\
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    mediainfo rclone \
    libnuma1 libssl1.1 libfreetype6



COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt


COPY . .

CMD ["python3", "-m", "termbot"]
