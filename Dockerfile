FROM ubuntu:18.04
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
