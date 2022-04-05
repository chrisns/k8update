FROM node:17.8.0-alpine@sha256:3981a6d3b7aa40192f7030f344f4e6f7ea6e932ab948e417407d6af2ca007226 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js