#!/bin/sh -l
contentful space export --mt=${INPUT_MANAGEMENT_TOKEN} \
    --space-id=${INPUT_SPACE_ID} \
    --include-drafts=${INPUT_INCLUDE_DRAFTS} \
    --environment-id=${INPUT_CONTENTFUL_ENVIRONMENT} --export-dir=/var/contentful/backup --download-assets=${INPUT_DOWNLOAD_ASSETS} \
    --max-allowed-limit=100 
TIMESTAMP=`date +%Y%m%d%H%M%S`

if test "$GITHUB_EVENT_NAME" = 'release'; then
  GIT_TAG=`node -e 'console.log(process.env.GITHUB_REF.split("/").pop() + "-")'`
fi

if test -n "$INPUT_PROJECT_NAME" ; then
  FOLDER_PREFIX=`echo ${INPUT_PROJECT_NAME}-`
fi

aws s3 cp /var/contentful/backup s3://${INPUT_BUCKET_NAME}/${FOLDER_PREFIX}${GIT_TAG}${TIMESTAMP} --recursive