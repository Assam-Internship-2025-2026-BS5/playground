# Stage 1: Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set the working directory to the playground folder
WORKDIR /app

# Copy both projects into the image
COPY designkit ./designkit
COPY playground ./playground

# Set the working directory for pub get and build
WORKDIR /app/playground

# Install dependencies and build the web application
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve the built web app using Nginx
FROM nginx:alpine

# Copy the built web artifacts from the first stage
COPY --from=build /app/playground/build/web /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
