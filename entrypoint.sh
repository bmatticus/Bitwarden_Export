#!/usr/bin/env bash
/etc/cont-init.d/10-adduser

Cyan='\033[0;36m'         # Cyan
if [[ -z "${FILE_LOG}" ]]; then
    su bitwarden -c /app/bw_export.sh 
else
    echo -e "\n${Cyan}Output log enabled: $FILE_LOG "
    su bitwarden -c /app/bw_export.sh  2>&1 | tee $FILE_LOG
fi