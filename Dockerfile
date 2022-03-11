FROM node:17.7.1-alpine@sha256:82c0402acb72a3c8f02a4ae43543f710d9868d5980de7c273646c9d9b4cd74f7 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js