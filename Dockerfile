# Getting node modules installed
FROM docker.io/library/node:22-alpine AS npm-builder

WORKDIR /src

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .
RUN npm run mdlint || true

# Getting hugo page build
FROM ghcr.io/hugomods/hugo:0.154.5 AS hugo-builder

WORKDIR /src

COPY --from=npm-builder /src/node_modules .
COPY . .
RUN hugo

# Creating deployment container
FROM docker.io/nginxinc/nginx-unprivileged:1.29-alpine

USER root

COPY nginx.conf /etc/nginx/nginx.conf

USER 101

COPY --from=hugo-builder /src/public /usr/share/nginx/html
