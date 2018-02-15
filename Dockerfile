FROM openjdk:latest

ADD . /app
WORKDIR /app
CMD [ "./grailsw", "run-app" ]