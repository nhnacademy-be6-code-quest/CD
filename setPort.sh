#!/bin/bash

# 현재 사용 중인 포트 확인
check_current_port() {
    netstat -tlnp | grep -E ":$PORT_1|:$PORT_2" | grep java | awk '{print $4}' | cut -c 4-
}

# 새로운 포트 결정
get_new_port() {
    CURRENT_PORT=$(check_current_port)
    if [ "$CURRENT_PORT" == "$PORT_1" ]; then
        echo $PORT_2
    else
        echo $PORT_1
    fi
}