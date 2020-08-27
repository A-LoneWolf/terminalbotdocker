FROM flaneurtv/ffmpeg:latest as xyz

FROM ubuntu:18.04

RUN mkdir -p /opt/ffmpeg
WORKDIR /opt/ffmpeg
COPY --from=xyz /opt/ffmpeg . 
RUN ln -s /opt/ffmpeg/share/model /usr/local/share/
RUN ldconfig
ENV PATH="/opt/ffmpeg/bin:$PATH"

WORKDIR     /app
RUN apt -qq update
RUN apt -qq install -y curl git gnupg2 wget \
    apt-transport-https \
    python3 python3-pip \
    coreutils aria2 jq pv \
    mediainfo rclone \
    libnuma1 libssl1.1 libfreetype6 libvmaf



COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt


COPY . .

CMD ["python3", "-m", "termbot"]
