FROM node:18.1.0-alpine@sha256:f4d6916c5625853e81994b5cb53ad3eb27e5fec9451c579d298fee0c508fe621 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js