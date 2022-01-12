FROM node:17.3.1-alpine@sha256:b19e09b20ce0f7908913cb97f8071e9d47b21fcc6544758a81308536cd7709c0 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js