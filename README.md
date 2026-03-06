# HDFC Design Kit Playground

A Flutter-based UI design kit and interactive playground.

## Architecture

Flutter Web → Docker → AWS ECS → Load Balancer

## Technologies

- Flutter
- Docker
- GitHub Actions
- AWS ECS
- Terraform

## Run locally

```
flutter pub get
flutter run
```

## Build Web

```
flutter build web
```

## Docker Build

```
docker build -t playground .
docker run -p 8080:80 playground
```

## CI/CD

GitHub Actions automatically:

1. Builds Flutter Web
2. Builds Docker image
3. Pushes image to Amazon ECR
4. Deploys to ECS