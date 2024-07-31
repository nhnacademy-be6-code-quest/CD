#!/bin/bash

# 스크립트 디렉토리 경로 설정
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 사용법 확인
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <PORT_1> <PORT_2> <JAR_FILE> <LOG_FILE>"
    exit 1
fi

PORT_1=$1
PORT_2=$2
JAR_FILE=$3
LOG_FILE=$4

# 다른 스크립트 실행
source "$SCRIPT_DIR/setPort.sh"
source "$SCRIPT_DIR/execute.sh"
source "$SCRIPT_DIR/terminate.sh"
source "$SCRIPT_DIR/healthCheck.sh"

# 메인 실행 로직
CURRENT_PORT=$(check_current_port)
NEW_PORT=$(get_new_port)
start_new_process $NEW_PORT $JAR_FILE $LOG_FILE

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