#!/usr/bin/env bash
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

DATE=$(date +"%Y%m%d%H%M")

BACKUP_DIR=/backup/xtra
mkdir -p "${BACKUP_DIR}"
BACKUP_DIR_DATE="${BACKUP_DIR}/${DATE}"
BACKUP_TAR_XZ_FILE_NAME="${BACKUP_DIR}/${DATE}.xtrbk.tar.xz"

/bin/rm -rf "${BACKUP_DIR:?}}"/* || echo 0

mkdir -p "${BACKUP_DIR}"

xtrabackup \
  -u ${USERNAME} \
  -p${PASSWORD} \
  --backup \
  --parallel=8 \
  --target-dir="${BACKUP_DIR_DATE}"

xtrabackup --prepare --target-dir="${BACKUP_DIR_DATE}"

tar -cpvf - "${BACKUP_DIR_DATE}" |
     xz -z -c -T6 -6 > "${BACKUP_TAR_XZ_FILE_NAME}"

rm -rf "${BACKUP_DIR_DATE}"
