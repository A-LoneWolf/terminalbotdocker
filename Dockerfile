FROM jrottenberg/ffmpeg:3.3
FROM ubuntu:18.04 
ENV TZ Asia/Kolkata

WORKDIR     /app
RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    rclone

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt


COPY . .

CMD ["python3", "-m", "termbot"]
