# The version of vmagent to install, check https://github.com/VictoriaMetrics/VictoriaMetrics/releases
VMAGENT_VERSION="${VMAGENT_VERSION:-v1.75.0}"

# The SHA256 hash of the "vmagent-prod" binary extracted from the vmutils archive.
#
# The value can be found in the released vmutils checksum file, for example in:
# https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.63.0/vmutils-amd64-v1.63.0_checksums.txt
VMAGENT_SHA256="${VMAGENT_SHA256:-2ce1aabaa96f46f5f4412a49d9a4cf4fb0e0b05873a7a9a7255b93bc746486eb}"
