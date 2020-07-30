FROM ubuntu:18.04

WORKDIR /app

RUN apt -qq update

ENV TZ Asia/Kolkata

RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    ffmpeg mediainfo rclone autoconf

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python3", "-m", "termbot"]
