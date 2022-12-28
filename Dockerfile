# Use the node:14 image as the base image
FROM node:14

# Set the working directory to the app's root
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the app's source code to the working directory
COPY . .

# Expose the app's port
EXPOSE 3000

# Run the app
CMD ["npm", "start"]
