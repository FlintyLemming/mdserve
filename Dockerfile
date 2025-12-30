FROM rust:1.85-bookworm AS build

WORKDIR /src
COPY Cargo.toml Cargo.lock ./
COPY src ./src
COPY templates ./templates
COPY static ./static
COPY build.rs ./

RUN cargo build --release

FROM debian:bookworm-slim

RUN useradd -r -u 10001 -g users mdserve

COPY --from=build /src/target/release/mdserve /usr/local/bin/mdserve
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod 0755 /usr/local/bin/mdserve /usr/local/bin/docker-entrypoint.sh

USER mdserve
WORKDIR /data

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
