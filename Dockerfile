FROM klakegg/hugo:0.111.3-ext-alpine AS builder

COPY . /src

RUN hugo --minify

FROM nginxinc/nginx-unprivileged:1.23-alpine

# prevent nginx from adding ports in redirects
USER root
COPY nginx.conf /etc/nginx/nginx.conf
USER 101

COPY --from=builder /src/public /usr/share/nginx/html
