# Stage 1: Build con Node.js
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Servidor Web de Producción (Nginx)
FROM nginx:1.25-alpine

# Copiar archivos compilados estáticos al directorio de Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Ajustar permisos para que Nginx corra en un entorno no-root (Seguridad corporativa)
RUN touch /var/run/nginx.pid && \
    chown -R 101:101 /var/run/nginx.pid /var/cache/nginx /var/log/nginx

USER 101
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]