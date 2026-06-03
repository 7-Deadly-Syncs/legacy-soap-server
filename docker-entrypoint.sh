#!/bin/bash

set -e

mkdir -p /app/data

touch \
    /app/data/sessions.dat \
    /app/data/balances.dat \
    /app/data/accounts.dat \
    /app/data/qris_transaction.dat

if [ ! -f /app/data/merchants.dat ]; then
cat > /app/data/merchants.dat <<EOF
M001|Indomaret Ketintang|Jl. Ketintang No. 123 Surabaya
M002|Alfamart Darmo|Jl. Raya Darmo No. 55 Surabaya
M003|Warung Pak Budi|Jl. Mangga No. 10 Surabaya
EOF
fi

exec /opt/apache-tomcat-8.5.96/bin/catalina.sh run
