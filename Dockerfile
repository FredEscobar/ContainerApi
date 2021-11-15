FROM node:lts-alpine@sha256:b8d48b515e3049d4b7e9ced6cedbe223c3bc4a3d0fd02332448f3cdb000faee1

#Node.js was not designed to run as PID 1 which leads to unexpected behaviour when running inside of Docker. 
#For example, a Node.js process running as PID 1 will not respond to SIGINT (CTRL-C) and similar signals”.
#The way to go about it then is to use a tool that will act like an init process, in that it is invoked with PID 1, 
#then spawns our Node.js application as another process whilst ensuring that all signals are proxied to that Node.js process.
#If possible, we’d like a small as possible tooling footprint for doing so to not risk having security vulnerabilities added to our container image.
#One such tool that we use at Snyk is dumb-init 
RUN apk add dumb-init

#Some frameworks and libraries may only turn on the optimized configuration that is suited to production 
#if that NODE_ENV environment variable is set to production
ENV NODE_ENV production

WORKDIR /usr/src/app
#Use the 'node' user as the owner of the files
COPY --chown=node:node . /usr/src/app
RUN npm ci --only=production

EXPOSE 80

#Run the process as 'node' user
USER node
CMD ["dumb-init", "node", "./bin/www"]