FROM ghcr.io/hugomods/hugo:0.154.5 AS builder

COPY . /src
RUN npm ci
RUN hugo --minify

FROM nginxinc/nginx-unprivileged:1.29-alpine

# prevent nginx from adding ports in redirects
USER root
COPY nginx.conf /etc/nginx/nginx.conf
USER 101

COPY --from=builder /src/public /usr/share/nginx/html
