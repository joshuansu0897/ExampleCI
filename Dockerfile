FROM node:carbon
EXPOSE 3000
WORKDIR /app
ADD package.json ./
RUN npm install
ADD . .
CMD ["node", "server"]