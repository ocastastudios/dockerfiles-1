#!/bin/bash
set -e

if [ ! "$MMS_API_KEY" ]; then
	{
		echo 'error: MMS_API_KEY was not specified'
		echo 'try something like: docker run -e MMS_API_KEY=... ...'
		echo '(see https://mms.mongodb.com/settings/backup-agent for your mmsApiKey)'
		echo
		echo 'Other optional variables:'
		echo ' - MMS_SERVER'
		echo ' - MMS_MUNIN'
		echo ' - MMS_CHECK_SSL_CERTS'
        echo ' - MMS_SSL'
        echo ' - MMS_CA_FILE'
	} >&2
	exit 1
fi

# "sed -i" can't operate on the file directly, and it tries to make a copy in the same directory, which our user can't do
config_tmp="$(mktemp)"
cat /etc/mongodb-mms/backup-agent.config > "$config_tmp"

set_config() {
	key="$1"
	value="$2"
	sed_escaped_value="$(echo "$value" | sed 's/[\/&]/\\&/g')"
	grep -q $key $config_tmp && sed -ri "s/^($key)[ ]*=.*$/\1 = $sed_escaped_value/" "$config_tmp" || echo $key=$sed_escaped_value >> $config_tmp
}

set_config mmsApiKey "$MMS_API_KEY"
if [ "$MMS_SERVER" ]; then
    set_config mmsBaseUrl "$MMS_SERVER"
fi
if [ "$MMS_MUNIN" ]; then
    set_config enableMunin "$MMS_MUNIN"
fi
if [ "$MMS_CHECK_SSL_CERTS" ]; then
    set_config sslRequireValidServerCertificates "$MMS_CHECK_SSL_CERTS"
fi
if [ "$MMS_SSL" ]; then
    set_config useSslForAllConnections "$MMS_SSL"
fi
if [ "$MMS_CA_FILE" ]; then
    set_config sslTrustedServerCertificates "$MMS_CA_FILE"
fi
if [ "$MMS_CLIENT_CERT" ]; then
    set_config sslClientCertificate "$MMS_CLIENT_CERT"
fi

cat "$config_tmp" > /etc/mongodb-mms/backup-agent.config
rm "$config_tmp"

exec "$@"
