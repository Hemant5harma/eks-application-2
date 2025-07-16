FROM node:18-alpine

COPY package*.json ./

RUN npm ci --only=production && npm cache clean --force

COPY . .


# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the application
CMD ["npm", "start"]