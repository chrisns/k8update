FROM node:17.8.0-alpine@sha256:c3956dc9f4bf08d1591ed6a5e611cefcdaf6764f9de34714a4e7cf7b2335bc56 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js