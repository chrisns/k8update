FROM node:17.8.0-alpine@sha256:cb273bf1e93f431f1e9f28b662f64e5e573c65c47c4f65e3b29d3136e0050f19 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js