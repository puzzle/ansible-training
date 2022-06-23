FROM klakegg/hugo:0.101.0-ext-alpine AS builder

COPY . /src

RUN hugo --minify

FROM nginxinc/nginx-unprivileged:1.23-alpine

# prevent nginx from adding ports in redirects
USER root
RUN sed -i '/^http {/a \    port_in_redirect off;' /etc/nginx/nginx.conf
USER 101

COPY --from=builder /src/public /usr/share/nginx/html
