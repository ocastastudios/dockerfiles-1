MongoDB Backup Agent
========================

A quick and easy MongoDB backup agent docker image  

Builds the latest version rather than having to update for every new release

Usage
-----
The following docker command will start the monitoring service.

`docker run -d -e MMS_API_KEY={YOUR_API_KEY} ocasta/mongodb-mms`

Environment Variables
-----

|  Name  | Config Variable it sets |
|--------|-------------------------|
| MMS_API_KEY | mmsApiKey |
| MMS_SERVER | mmsBaseUrl |
| MMS_MUNIN | enableMunin |
| MMS_CA_FILE | sslTrustedServerCertificates |
| MMS_CLIENT_CERT | sslClientCertificate |
| MMS_CHECK_SSL_CERTS | sslRequireValidServerCertificates |
| MMS_SSL | useSslForAllConnections |
