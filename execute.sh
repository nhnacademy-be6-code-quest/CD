#!/bin/bash

# 새로운 프로세스 시작 함수
start_new_process() {
    NEW_PORT=$1
    JAR_FILE=$2
    echo "Starting new process on port $NEW_PORT..."
    nohup java -jar ./target/$JAR_FILE --server.port=$NEW_PORT --spring.profiles.active=prod > client_log_$NEW_PORT 2>&1 &
    echo "New process started on port $NEW_PORT."
}