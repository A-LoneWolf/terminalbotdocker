FROM ubuntu:18.04
FROM offbytwo/ffmpeg:latest 
ENV TZ Asia/Kolkata
RUN pwd
WORKDIR     /app
RUN pwd
RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    mediainfo rclone
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt


COPY . .
RUN pwd
RUN ls
CMD ["python3", "-m", "termbot"]
