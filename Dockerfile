# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy all other application files
COPY . .

# Expose the port
EXPOSE 8080

# Start the application
CMD ["npm", "start"]
