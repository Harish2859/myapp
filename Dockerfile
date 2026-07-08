# Stage 1: Build
FROM node:20 AS build
WORKDIR /app
COPY . .
WORKDIR /app/myApp
RUN npm install
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=build /app/myApp/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]