# Variables - API_KEY set through workflow variable
FILE_PATH=$1

# Check whether file exists
if [ ! -f "$FILE_PATH" ]; then
  echo "Error: The files '$FILE_PATH' does not exist."
  exit 1
fi

# Upload file
response=$(curl --request POST \
     --url https://www.virustotal.com/api/v3/files \
     --header 'accept: application/json' \
     --header 'content-type: multipart/form-data' \
     --header "x-apikey: $API_KEY" \
     --form "file=@\"$FILE_PATH\"")

# Extract analysis-id
analysis_id=$(echo "$response" | jq -r '.data.id' | base64 --decode)

# Only extract part before the ":"
short_id=${analysis_id%%:*}

# Open URL in the browser
if [ -n "$analysis_id" ]; then
  echo "Analyse-ID: $analysis_id and Short-ID: $short_id"
  echo "Open VirusTotal GUI..."
  open "https://www.virustotal.com/gui/file/$short_id"
else
  echo "Error uploading file or parsing analysis id"
fi
