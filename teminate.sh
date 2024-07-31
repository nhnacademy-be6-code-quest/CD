#!/bin/bash

# 프로세스 종료 함수
terminate_process() {
    PORT=$1
    JAR_FILE=$2
    PID=$(ps -ef | grep "$JAR_FILE" | grep "$PORT" | grep -v grep | awk '{print $2}')
    if [ -n "$PID" ]; then
        echo "Terminating process on port $PORT with PID: $PID"
        kill -15 $PID
        echo "Process terminated."
    else
        echo "No process found on port $PORT."
    fi
}