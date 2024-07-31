#!/bin/bash

# 헬스 체크 함수
health_check() {
    PORT=$1
    for i in {1..10}
    do
        sleep 6
        STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/actuator/health)
        if [ $STATUS == "200" ]; then
            echo "Health check passed on port $PORT"
            return 0
        fi
    done
    echo "Health check failed on port $PORT"
    return 1
}