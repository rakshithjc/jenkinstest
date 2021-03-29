FROM node:10-alpine
# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

COPY wait-for-it.sh /usr/wait-for-it.sh
RUN chmod +x /usr/wait-for-it.sh

#RUN export PG_HOST=`postgres`
#RUN export PG_PASSWORD=`postgres`
#RUN export PG_DB=`postgres`

ENV PG_HOST=process.env.PG_HOST
ENV PG_PASSWORD=process.env.PG_PASSWORD
ENV PG_DB=process.env.PG_DB

EXPOSE 4000
CMD ["npm", "start"]