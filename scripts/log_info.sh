#!/bin/bash

LOGS_DIR="$HOME/my_first_de_project/logs/"
LOG_FILE="$LOGS_DIR/project1.log"

mkdir -p "$LOGS_DIR"

log_info() {
		echo "$(date '+%Y-%m-%d %H-%M-%S') | INFO | $1" >> "$LOG_FILE"
}

log_error() {
		echo "$(date '+%Y-%m-d %H-%M-%S') | ERROR | $1" >> "$LOG_FILE"
}



