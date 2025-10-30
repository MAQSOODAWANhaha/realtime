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

# 创建Caddy证书存储目录（使用root权限创建，后续caddy用户可以访问）
RUN mkdir -p /data /config

COPY --from=build-stage /app/dist /app/dist
COPY Caddyfile /etc/caddy/Caddyfile

# 确保目录权限正确（caddy容器默认以caddy用户运行）
# 由于使用挂载卷，权限会在运行时由docker-compose管理

EXPOSE 80
EXPOSE 443
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
