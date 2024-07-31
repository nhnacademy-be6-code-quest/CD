#!/bin/bash

# 사용법 확인
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <PORT_1> <PORT_2> <JAR_FILE>"
    exit 1
fi

PORT_1=$1
PORT_2=$2
JAR_FILE=$3

# 다른 스크립트 실행
source ./setPort.sh
source ./execute.sh
source ./terminate.sh
source ./healthCheck.sh

# 메인 실행 로직
CURRENT_PORT=$(check_current_port)
NEW_PORT=$(get_new_port)
start_new_process $NEW_PORT $JAR_FILE

if health_check $NEW_PORT; then
    echo "Waiting for 1 minute before switching traffic..."
    sleep 60
    
    if [ -n "$CURRENT_PORT" ]; then
        echo "Switching off the old instance..."
        curl -X POST http://localhost:$CURRENT_PORT/actuator/shutdown
        echo "Waiting for 1 minute before terminating the old process..."
        sleep 60
        terminate_process $CURRENT_PORT $JAR_FILE
    fi
    
    echo "Deployment completed successfully."
else
    echo "New instance failed to start. Rolling back..."
    terminate_process $NEW_PORT $JAR_FILE
fi