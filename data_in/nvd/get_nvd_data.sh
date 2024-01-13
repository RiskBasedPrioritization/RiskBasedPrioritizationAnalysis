#!/bin/bash



mkdir -p jsondata
cd jsondata
rm *.json 
rm *.zip 

# The following command / expansion may not work in all environments 
# wget https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-{2002..2023}.json.zip 
# so an alternative is  given here


# Base URL for the NIST NVD data
base_url="https://nvd.nist.gov/feeds/json/cve/1.1/"

# Define the range of years 
start_year=2002
end_year=2023

# Loop through the years and download files for each year
for ((year=start_year; year<=end_year; year++)); do
    file_name="nvdcve-1.1-${year}.json.zip"
    url="${base_url}${file_name}"
    
    # Use wget to download the files to dir jsondata
    wget "$url" 
    
done

unzip -o "*.zip"


date > ../date.txt

