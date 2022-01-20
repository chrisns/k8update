FROM node:17.4.0-alpine@sha256:1f839187b06dc12887361b1d648e617de566b076f6fd3a35f80de5a3c1b70255 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js