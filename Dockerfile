FROM alpine:latest

RUN apk add --no-cache wget curl aria2

WORKDIR /downloads

COPY urls.txt .

RUN mkdir -p /downloads/files && \
    while IFS= read -r url || [[ -n "$url" ]]; do \
        # Skip empty lines and comments
        [[ -z "$url" || "$url" =~ ^[[:space:]]*# ]] && continue; \
        echo "Downloading: $url"; \
        filename=$(basename "$url" | cut -d'?' -f1); \
        wget -q --show-progress -O "/downloads/files/${filename}" "$url" || \
        curl -L -o "/downloads/files/${filename}" "$url" || \
        aria2c -d /downloads/files -o "${filename}" "$url"; \
    done < urls.txt

# Create a simple index file
RUN ls -la /downloads/files > /downloads/index.txt && \
    echo "Download completed at $(date)" >> /downloads/index.txt