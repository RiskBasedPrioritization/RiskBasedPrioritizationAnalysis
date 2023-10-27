# Get NVD data CVSS v3 only
# -------------------------
# NOTE: some CVEs won't have values for these fields because the file contains
#   rejected CVEs i.e. the CVE was created for a vulnerability but then rejected
#   CVEs with versions other than CVSS v3. CVEs from ~2016 onwards have CVSS v3. Prior to that CVEs had CVSS v2.

mkdir tmp

#Note: This will no longer work after Dec 2023 per https://nvd.nist.gov/vuln/data-feeds 
wget https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-{1999..2023}.json.zip -P ./tmp

for f in ./tmp/nvdcve-1.1-*.json.zip ; do
    echo "$f"
    unzip  "$f" -d ./tmp/
done

# Get these fields from CVSS v3:
#   CVE ID
#   attackComplexity
#   attackVector
#   userInteraction
#   availabilityImpact
#   privilegesRequired
#   confidentialityImpact
#   integrityImpact
# CVE Description is .cve.description.description_data[0].value'
#  
#  Extract example from NVD CVE json file for reference:
#    "impact" : {
#      "baseMetricV3" : {
#        "cvssV3" : {
#          "version" : "3.1",
#          "vectorString" : "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H",
#          "attackVector" : "NETWORK",
#          "attackComplexity" : "LOW",
#          "privilegesRequired" : "NONE",
#          "userInteraction" : "NONE",
#          "scope" : "UNCHANGED",
#          "confidentialityImpact" : "NONE",
#          "integrityImpact" : "NONE",
#          "availabilityImpact" : "HIGH",
#          "baseScore" : 7.5,
#          "baseSeverity" : "HIGH"
#        },
#        "exploitabilityScore" : 3.9,
#        "impactScore" : 3.6
#      },
echo "CVE,baseScore,attackComplexity,attackVector,userInteraction,privilegesRequired,confidentialityImpact,integrityImpact,availabilityImpact" > ./nvd_cves.csv

for f in ./tmp/nvdcve-1.1-*.json ; do
    echo "$f"
    cat "$f" | jq '.CVE_Items[] | .cve.CVE_data_meta.ID +  "," +(.impact.baseMetricV3.cvssV3.baseScore|tostring) +  "," + .impact.baseMetricV3.cvssV3.attackComplexity +  "," + .impact.baseMetricV3.cvssV3.attackVector +  "," + .impact.baseMetricV3.cvssV3.userInteraction +  "," + .impact.baseMetricV3.cvssV3.privilegesRequired  +  "," + .impact.baseMetricV3.cvssV3.confidentialityImpact +  "," + .impact.baseMetricV3.cvssV3.integrityImpact +  "," + .impact.baseMetricV3.cvssV3.availabilityImpact' | cut -d\" -f2 >> ./nvd_cves.csv
done

grep -v ',,,,,,' ./nvd_cves.csv > ./nvd_cves_v3.csv #drop the CVEs with no CVSS v3 parameters e.g. REJECTED CVEs
gzip -f ./nvd_cves_v3.csv

#remove temporary files
rm -f ./nvd_cves.csv
rm -fr tmp