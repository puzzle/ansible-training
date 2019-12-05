ARG HUGO_VERSION=0.59.1

FROM registry.puzzle.ch/puzzle/hugo:${HUGO_VERSION} AS builder

EXPOSE 8080

RUN mkdir -p /opt/app/src/static && \
    chmod -R og+rwx /opt/app

WORKDIR /opt/app/src

ARG HUGO_BASE_URL
ENV HUGO_BASE_URL $HUGO_BASE_URL

COPY . /opt/app/src

RUN hugo --baseURL=${HUGO_BASE_URL:-http://localhost/} \
  --theme ${HUGO_THEME:-dot} --minify

FROM nginxinc/nginx-unprivileged:alpine

COPY --from=builder  /opt/app/src/public /usr/share/nginx/html
