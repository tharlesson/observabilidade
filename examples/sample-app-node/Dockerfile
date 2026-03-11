FROM node:22-alpine

WORKDIR /app
COPY package.json /app/package.json
RUN npm install --omit=dev
COPY app.js /app/app.js

ENV PORT=8080
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD wget -qO- http://localhost:8080/healthz || exit 1

CMD ["npm", "start"]
