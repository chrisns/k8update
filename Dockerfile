FROM node:18.0.0-alpine@sha256:1e51561b49be84676669cdc824069546171ed0a6a00eb0ee4a56d490fb8743a8 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js