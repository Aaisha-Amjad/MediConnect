FROM ballerina/ballerina:latest

WORKDIR /ballerina

COPY prescription-orchestrator/ ./prescription-orchestrator/

WORKDIR /ballerina/prescription-orchestrator

RUN bal build

EXPOSE 8080

CMD ["bal", "run"]
