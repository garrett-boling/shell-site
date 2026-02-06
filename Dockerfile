FROM alpine:3.20 AS build
RUN apk add --no-cache bash make curl jq python3 figlet
WORKDIR /app
COPY . .
RUN make build

FROM caddy:2.8-alpine
COPY --from=build /app/_site /srv
COPY Caddyfile /etc/caddy/Caddyfile
