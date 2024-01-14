FROM ubuntu:22.04

LABEL description="Bitwarden exporter docker container"
LABEL version="0.2"
# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && apt-get install -y unzip jq && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Installing last version of Bitwarden CLI
ADD https://vault.bitwarden.com/download/?app=cli&platform=linux /tmp/bw.zip
RUN unzip /tmp/bw.zip && chmod +x /app/bw && install /app/bw /usr/local/bin/

# Copy script
COPY bw_export.sh /app/bw_export.sh 
ENTRYPOINT ["/app/bw_export.sh"]
