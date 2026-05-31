FROM ballerina/ballerina:2201.8.0
WORKDIR /app
COPY prescription-orchestrator/ .
RUN bal build
EXPOSE 8080
CMD ["bal", "run", "target/bin/prescription_orchestrator.jar"]