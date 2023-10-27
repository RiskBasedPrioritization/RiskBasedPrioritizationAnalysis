#!/bin/sh

# Following Code based on https://github.com/jgamblin/patchthisapp/blob/main/.github/workflows/patchthis.yml 

# Get EPSS data 
wget https://epss.cyentia.com/epss_scores-current.csv.gz -O ./epss/epss.csv.gz 

# Get MetaSploit data 
curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/db/modules_metadata_base.json | jq '.[]|{cve:.references[]|select(startswith("CVE-"))}| join(",")' > ./metasploit/metasploit.txt

# Get Nuclues data
curl https://raw.githubusercontent.com/projectdiscovery/nuclei-templates/main/cves.json | jq -r .ID > ./nuclei/nuclei.txt

# Get CISA KEV data
wget https://www.cisa.gov/sites/default/files/csv/known_exploited_vulnerabilities.csv -O ./cisa_kev/known_exploited_vulnerabilities.csv
gzip -f ./cisa_kev/known_exploited_vulnerabilities.csv