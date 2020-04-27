#!/bin/bash
if [ -z "${USER}" ]
then
  echo -n "MySQL username: " ; read -r USERNAME
else
    USERNAME="${USER}"
fi
if [ -z "${MYSQL_PWD}" ]
then
  echo -n "MySQL password: " ; stty -echo ; read -r PASSWORD ; stty echo ; echo
else
  PASSWORD="${MYSQL_PWD}"
fi

BACKUP_DIR=/backup
BACKUP_FILE=$(date +"%Y%m%d%H%M")

rm -rf "${BACKUP_DIR:?}/"

/usr/bin/mysqldump \
  -h 127.0.0.1 \
  -u ${USERNAME} \
  -p${PASSWORD} \
  --lock-tables \
  --complete-insert \
  --extended-insert \
  --single-transaction \
  --routines \
  --triggers \
  --force \
  --add-drop-database \
  --all-databases \
  --default-character-set=utf8mb4 | xz -z -c -T6 -6 > "${BACKUP_DIR}"/"${BACKUP_FILE}".sql.xz
