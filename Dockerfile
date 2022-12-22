################
##### Builder
FROM rust:1.66-alpine as base

# Set the working directory
WORKDIR /usr/src

## Install target platform (Cross-Compilation) --> Needed for Alpine
RUN rustup target add x86_64-unknown-linux-musl

## Install openssl libs
RUN apk add --update-cache musl-dev libressl-dev && rm -rf /var/cache/apk/*

# Create blank project
RUN USER=root cargo new app -q
WORKDIR /usr/src/app
COPY Cargo.toml Cargo.lock /usr/src/app/

# ################
# ##### Dev Container
FROM base as dev
RUN cargo install cargo-watch
RUN cargo build --locked
EXPOSE 3030
COPY src ./src/
CMD ["cargo", "watch", "-x", "run -- -a 0.0.0.0 -p 3030"]

# ################
# ##### Builder
FROM base as builder
# This is a dummy build to get the dependencies cached.
RUN cargo build --target x86_64-unknown-linux-musl --release --locked
# Now copy in the rest of the sources
COPY src ./src/
# Touch main.rs to prevent cached release build
RUN touch /usr/src/app/src/bin/main.rs
# This is the actual application build.
RUN cargo install --target x86_64-unknown-linux-musl --locked --path .

# ################
# ##### Runtime
FROM scratch as release
COPY --from=builder /usr/local/cargo/bin/main .
USER 1000
EXPOSE 3030
CMD ["./main", "-a", "0.0.0.0", "-p", "3030"]