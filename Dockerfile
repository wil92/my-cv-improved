FROM node:18.19.1-alpine3.19 AS build-env

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY src ./src
COPY public ./public
COPY tsconfig.json astro.config.mjs ./

RUN npm run build

FROM nginx:1.25.4-alpine

COPY --from=build-env /app/dist/ /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
