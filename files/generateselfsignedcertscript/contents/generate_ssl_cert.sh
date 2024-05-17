#!/usr/bin/bash
echo "INFO:Generating SSL keys for ${targetServerLin.fqn}"
echo ""
grep -q sslcerts /etc/group || groupadd --gid 330 sslcerts
usermod -G sslcerts apache

#now generate the keys
openssl req -nodes -x509 -sha256 -newkey rsa:4096 \
  -keyout ${targetServerLin.hostname}.key \
  -out ${targetServerLin.hostname}.crt \
  -days 3650 \
  -subj "/C=AU/ST=QLD/L=Brisbane/O=Synerty/OU=Synerty Peek/CN=${targetServerLin.hostname}" \
  -extensions san \
  -config <( \
  echo '[req]' ; \
  echo 'distinguished_name=req' ; \
  echo '[san]' ; \
  echo "subjectAltName=DNS:${targetServerLin.hostname},DNS:${targetServerLin.fqn},DNS:${targetServerLin.Ip}")

mv ${targetServerLin.hostname}.crt /etc/ssl/certs/
mv ${targetServerLin.hostname}.key /etc/pki/tls/private
chgrp sslcerts /etc/pki/tls/private/${targetServerLin.hostname}.key
chmod 660 /etc/pki/tls/private/${targetServerLin.hostname}.key

echo ""
echo "INFO:SSL keys generated successfully"