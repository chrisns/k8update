FROM node:18.2.0-alpine@sha256:a8409dff6597f2ef5f7ecd3c672671bb2af9a390073efd74f95c54aa41cba22a 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js