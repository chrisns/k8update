FROM node:17.7.1-alpine@sha256:e0419acec75ab3eb99f74641e82647d10c1da959bbbf007d4e26a170894590c3 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js