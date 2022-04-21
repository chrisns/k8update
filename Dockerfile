FROM node:18.0.0-alpine@sha256:505bb54d5a7380b805d68db9822dd20844c0d348f4f96ccc57e1a240cba57236 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js