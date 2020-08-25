FROM ubuntu:18.04
FROM spiderxd/ffmpeg-ubuntu:latest 
ENV TZ Asia/Kolkata

WORKDIR     /app

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt


COPY . .

CMD ["python3", "-m", "termbot"]
