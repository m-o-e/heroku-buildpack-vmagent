# The version of vmagent to install, check https://github.com/VictoriaMetrics/VictoriaMetrics/releases
VMAGENT_VERSION="${VMAGENT_VERSION:-v1.63.0}"

# The SHA256 hash of the "vmagent-prod" binary extracted from the vmutils archive.
#
# The value can be found in the released vmutils checksum file, for example in:
# https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.63.0/vmutils-amd64-v1.63.0_checksums.txt
VMAGENT_SHA256="${VMAGENT_SHA256:-b2073e0b624f7746334862359608b16327ac7c2d95929838d29637f7903b97cc}"
