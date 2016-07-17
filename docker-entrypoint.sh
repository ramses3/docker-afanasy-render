#!/bin/bash

set -e

echo "Setting AF_SERVERNAME to $AF_SERVERNAME"
sed -i s/afanasyServer/$AF_SERVERNAME/ /opt/cgru/afanasy/config_default.json  

exec "$@"
