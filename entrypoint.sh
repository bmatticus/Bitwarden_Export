#!/usr/bin/env bash
/etc/cont-init.d/10-adduser
su bitwarden -c /app/bw_export.sh 
