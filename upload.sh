#!/bin/bash

function upload_gzip() {
    PATTERN=$1
    WHERE=$2

    gzip $PATTERN
    aws s3 cp --exclude ".git/*" --content-encoding gzip $PATTERN.gz s3://open.ashannon.us/$WHERE
}

function uncompress_files() {
    REQUIRED_PATTERN=$1
    GIVEN_PATTERN=$2
    if [[ -n "$GIVEN_PATTERN" ]];
    then
        gzip -d $GIVEN_PATTERN
    else
        echo "gzip -d $REQUIRED_PATTERN";
        gzip -d $REQUIRED_PATTERN
    fi
}

function upload_html() {
    BASE=$1
    WHERE=$2
    upload_gzip "$BASE*.html" $WHERE
    uncompress_files "*.html.gz" $BASE
}

function upload_css() {
    BASE=$1
    WHERE=$2
    aws s3 cp --exclude ".git/*" --content-encoding gzip $BASE*css s3://open.ashannon.us/$WHERE
}


# Upload main site files
upload_html
upload_css
