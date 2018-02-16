FROM openjdk:latest

ADD . /app
WORKDIR /app
RUN ./grailsw compile

CMD [ "./grailsw", "run-app" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "curl -f http://localhost:8080/ || exit 1" ]