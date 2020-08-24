FROM ubuntu:18.04

RUN apt -qq update

ENV TZ Asia/Kolkata
RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    mediainfo rclone
RUN apt-get install -y software-properties-common

RUN sudo apt-get update; \
    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo apt-key fingerprint 0EBFCD88
RUN sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN sudo apt-get update; \
RUN sudo apt-get install docker-ce docker-ce-cli containerd.io


RUN docker pull jrottenberg/ffmpeg

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt


COPY . .

CMD ["python3", "-m", "termbot"]
