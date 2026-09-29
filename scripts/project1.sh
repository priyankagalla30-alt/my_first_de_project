#!/bin/bash

INPUT_DIR="$HOME/my_first_de_project/input/"
LOGS_DIR="$HOME/my_first_de_project/logs/"
LOG_FILE="$LOGS_DIR/project1.log"
ARCHIVE_DIR="$HOME/my_first_de_project/archive/"
S3_BUCKET="s3://priya-de-project-2026/raw/incoming/"

source ./log_info.sh

max_retries=3
log_info "Job started"

mkdir -p "$LOGS_DIR"

if [ ! -d "$INPUT_DIR" ]
then
	log_error "$INPUT_DIR - Directory doen't exist" 
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
        log_info "Processing the $file"
done

	if [ ! -f "$file" ]
	then
		log_error "file doesn't exist"
	fi


	if [ ! -s "$file" ]
	then
		log_error "$file is empty"
	continue
	fi



attempt=1
uploaded=false

while [ "$attempt" -le "$max_retries" ]
do
	log_info "Uploading to s3 $file in progress - attempt $attempt"

	if aws s3 cp "$file" "$S3_BUCKET"
	then
		log_info "$file has been uploaded successfully"
		uploaded=true
		break
 	fi
	log_error "Failed to upload the file - $file"
	attempt=$((attempt + 1))
	if [ $attempt -le $max_retries ]
	then
		sleep 10
	fi
done

if [ "$uploaded" = true ]
then
	if mv "$file" "$ARCHIVE_DIR"
	then
		log_info "$file moved to archive successfully"
	else
		log_error "$file not moved to archive location"
	fi
else
	log_error "upload failed after trying $attempt attempt and $max_retries"
fi
