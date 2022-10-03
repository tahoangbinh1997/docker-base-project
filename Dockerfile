FROM node:alpine as frontend

ENV PORT 5000

# where our Next.js app will live
RUN mkdir -p /app

# Set /app as the working directory
WORKDIR /app

# Copy package.json and package-lock.json
# to the /app working directory
COPY ./svelte-build-project/package*.json /app/
COPY ./svelte-build-project/yarn.lock /app/
COPY ./.env /app/

# Install dependencies in /app
RUN rm -rf ./svelte-build-project/node_modules && yarn install

# Copy the rest of our Next.js folder into /app
COPY ./svelte-build-project /app/

# Ensure port 5000 is accessible to our system
EXPOSE 5000

# Run yarn dev, as we would via the command line 
CMD [ "node", "build" ]