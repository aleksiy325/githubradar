FROM node:carbon

WORKDIR /usr/app
COPY package*.json ./
RUN npm install 
COPY . .
RUN npm build

EXPOSE 5000
CMD serve ./build