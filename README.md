# Rust Dockerized API Example

## For development

### Directly

```sh
cargo run -- -p 3000
curl http://localhost:3000
```

### With Watcher

```sh
cargo install cargo-watch
cargo watch -x "run -- p 3000"
curl http://localhost:3000
```

### Docker Compose

```sh
docker-compose -d up
```

## Running a production like version

```sh
docker-compose -f docker-compose-prod.yaml up --build
```

## Build production image

```sh
docker build -t rust_dockerized_api --target release .
```
