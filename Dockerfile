# Use an official Node.js runtime as a parent image (using a smaller, lighter base image)
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies efficiently
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code to the working directory
COPY . .

# Ensure the app runs as a non-root user for security reasons
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose the port the app runs on
EXPOSE 8080

# Start the application
CMD ["npm", "start"]
