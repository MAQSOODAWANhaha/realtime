# build stage
FROM node:18-alpine AS build-stage
WORKDIR /app
COPY package.json pnpm-lock.yaml .npmrc ./
RUN npm install -g pnpm && pnpm install
COPY . .
RUN pnpm build:prod

# production stage
FROM caddy:2-alpine AS production-stage
WORKDIR /app

# 创建Caddy证书存储目录
RUN mkdir -p /data /config && \
    chown -R caddy:caddy /data /config

COPY --from=build-stage /app/dist /app/dist
COPY Caddyfile /etc/caddy/Caddyfile

# 切换到caddy用户
USER caddy

EXPOSE 80
EXPOSE 443
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
