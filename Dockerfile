FROM klakegg/hugo:0.80.0-ext-alpine AS builder

COPY . /src

RUN hugo --minify

FROM nginxinc/nginx-unprivileged:alpine

EXPOSE 8080

COPY --from=builder /src/public /usr/share/nginx/html