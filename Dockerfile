FROM --platform=linux/amd64 docker.io/node:alpine AS builder

ENV HUSKY=0
WORKDIR /build

COPY . .

RUN corepack enable
RUN corepack prepare pnpm@latest --activate
RUN pnpm install
RUN pnpm build

FROM docker.io/caddy:alpine

EXPOSE 80

WORKDIR /srv

COPY --from=builder /build/dist/. .
COPY Caddyfile .

CMD ["caddy", "run"]
