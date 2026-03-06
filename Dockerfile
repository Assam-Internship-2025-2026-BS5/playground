# Stage 1: Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy playground code
COPY playground/ /app/

# Copy designkit dependency
COPY designkit/ /designkit/

# Update dependency path
RUN sed -i 's|../designkit|/designkit|g' pubspec.yaml

# Install dependencies
RUN flutter pub get

# Build web app
RUN flutter build web

# Stage 2: Serve with nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]