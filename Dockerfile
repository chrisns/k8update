FROM node:17.3.0-alpine@sha256:4dd690ef859ceadc242e9901fb554ce0a97a9055f33b9cf4ea441acdbfe50a34 
RUN apk add --no-cache skopeo
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY index.js ./
CMD node /app/index.js