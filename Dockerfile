# build stage
FROM node:18-alpine as build-stage
WORKDIR /app
COPY package.json pnpm-lock.yaml .npmrc ./
RUN npm install -g pnpm && pnpm install
COPY . .
RUN pnpm build

# production stage
FROM caddy:2-alpine as production-stage
WORKDIR /app
COPY --from=build-stage /app/dist /app/dist
COPY Caddyfile /etc/caddy/Caddyfile
EXPOSE 80
EXPOSE 443
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
