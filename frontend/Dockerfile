# Create file: frontend/Dockerfile
FROM node:14-alpine

WORKDIR /app

# Copy package.json first for better caching
COPY package.json /app/

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY App.js /app/
COPY index.html /app/

# Install a simple HTTP server to serve the static content
RUN npm install -g serve

# Expose port 80
EXPOSE 80

# Start the server
CMD ["serve", "-s", ".", "-l", "80"]
