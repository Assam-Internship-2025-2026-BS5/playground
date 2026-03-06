# Stage 1 — Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy playground project
COPY . .

# Copy designkit dependency
COPY ../designkit /designkit

# Fix dependency path
RUN sed -i 's|../designkit|/designkit|g' pubspec.yaml

RUN flutter pub get
RUN flutter build web

# Stage 2 — Serve with nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]