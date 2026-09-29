#!/bin/bash

INPUT_DIR="$HOME/my_first_de_project/input/"
ARCHIVE_DIR="$HOME/my_first_de_project/archive/"
LOG_DIR="$HOME/my_first_de_project/logs/"
LOG_FILE="$LOG_DIR/etl.log"

S3_BUCKET="s3://priya-de-project-2026/raw/incoming/"
MAX_RETRIES=3

mkdir -p "$LOG_DIR"

log_info(){
		echo "$(date '+%Y-%m-%d %H-%M-%S') | INFO | $1" >> "$LOG_FILE"
}


log_error(){
		echo "$(date '+%Y-%m-%d %H-%M-%S') | ERROR | $1" >> "$LOG_FILE"
}

log_info "Job Started"

if [ ! -d "$INPUT_DIR" ]
then
   log_error "Directory doesn't exist"
   exit 1
fi



files=("$INPUT_DIR"/*.csv)

if [ ! -e "${files[0]}" ]
then
	log_error "csv files are not found"
	exit 0
fi

for file in "${files[@]}"
do
	log_info "Processing the file: $file"
done

if [ ! -s "$file" ]
    then
        log_error "File is empty: $filename"
        continue
    fi

attempt=1
uploaded=false

while [ $attempt -le $MAX_RETRIES ]
do
	log_info "Uploading $file - attempt $attempt"

	aws s3 cp "$file" "$S3_BUCKET"

	if [ $? -eq 0 ]
	then
		uploaded=true
		break
        fi

	log_error "uploaded failed $file - attempt $attempt"
	attempt=$((attempt + 1))

	if [ $attempt -le $MAX_RETRIES ]
        then
		sleep 10
	fi
done


if [ "$uploaded" = true ]
then
	log_info "successfully uploaded: $file"

	mv "$file" "$ARCHIVE_DIR/"

	if [ "$?" -eq 0 ]
	then
		log_info "moved to archive: $file"
	else
		log_error "Failed to move archive location : $ file"
	fi
else
	log_error "upload failed after $MAX_RETRIES attempts: $file"
fi

















 



















