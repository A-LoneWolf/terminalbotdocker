FROM ubuntu:18.04
RUN apt -qq update
RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    mediainfo rclone

FROM offbytwo/ffmpeg:latest 
ENV TZ Asia/Kolkata
RUN pwd
WORKDIR     /app
RUN pwd

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt


COPY . .
RUN pwd
RUN ls
CMD ["python3", "-m", "termbot"]
