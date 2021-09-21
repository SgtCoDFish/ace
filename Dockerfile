FROM gcr.io/distroless/static@sha256:ef0dddb6c0595a9f4414922fe3f0f7d9ce067e1eb852961720135e60586febba

COPY bin/main /main

ENTRYPOINT ["/main"]
