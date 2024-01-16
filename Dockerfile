FROM ubuntu:22.04

LABEL description="Bitwarden exporter docker container"
LABEL version="0.2"

# Create a volume for storing vault exporting data
VOLUME /var/data
# Create a volume for storing attachments files in vault
VOLUME /var/attachments

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && apt-get install -y unzip jq && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Installing last version of Bitwarden CLI
ADD https://vault.bitwarden.com/download/?app=cli&platform=linux /tmp/bw.zip

# Copy script
COPY bw_export.sh /app/bw_export.sh 

# Run multiple tasks
RUN unzip /tmp/bw.zip && chmod +x /app/bw  && install /app/bw /usr/local/bin/ && chmod +x /app/bw_export.sh

ENTRYPOINT ["/app/bw_export.sh"]
