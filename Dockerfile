FROM node:alpine as frontend

ENV PORT 5000

# where our Next.js app will live
RUN mkdir -p /frontend/app

# Set /app as the working directory
WORKDIR /frontend/app

# Copy package.json and package-lock.json
# to the /app working directory
COPY ./svelte-build-project/package*.json /frontend/app/
COPY ./svelte-build-project/yarn.lock /frontend/app/
COPY ./.env /frontend/app/

# Install dependencies in /app
RUN rm -rf ./svelte-build-project/node_modules && yarn install

# Copy the rest of our Next.js folder into /app
COPY ./svelte-build-project /frontend/app/

# Ensure port 5000 is accessible to our system
EXPOSE 5000

# Run yarn dev, as we would via the command line 
CMD [ "node", "build" ]

FROM node:16 as backend
# Installing libvips-dev for sharp Compatability
# RUN apt-get update && apt-get install libvips-dev vim -y

# where our Strapi app will live
RUN mkdir -p /backend/app

# Set /app as the working directory
WORKDIR /backend/app

# Copy package.json and package-lock.json
# to the /app working directory
COPY ./basic_strapi/package*.json /backend/app/
COPY ./basic_strapi/yarn.lock /backend/app/
COPY ./.env /backend/app/

ENV PATH /app/node_modules/.bin:$PATH

# Install dependencies in /app
RUN rm -rf ./basic_strapi/node_modules && yarn install

# Copy the rest of our Strapi folder into /app
COPY ./basic_strapi /backend/app

EXPOSE 1337

# For production build
ENV NODE_ENV=${NODE_ENV}

# Run yarn dev, as we would via the command line 
CMD ["node", "build"]
