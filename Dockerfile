FROM node:17.7.2-alpine@sha256:b6c95e22965ed1e9b0a2cc1362c3e1b3e25d9d10b7ceacde40cea859f5b3ffb6 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js