#!/bin/bash
if [ -z "${USER}" ]
then
  echo -n "MySQL username: " ; read -r DB_USERNAME
else
    DB_USERNAME="${USER}"
fi
if [ -z "${MYSQL_PWD}" ]
then
  echo -n "MySQL password: " ; stty -echo ; read -r PASSWORD ; stty echo ; echo
else
  PASSWORD="${MYSQL_PWD}"
fi


BACKUP_DATE=$(date +"%Y%m%d%H%M")
BACKUP_DIR="/backup/seperate/${BACKUP_DATE}"

rm -rf "${BACKUP_DIR:?}/*"

mkdir -p "${BACKUP_DIR}"

DB_NAMES=$(\
    mysql -s -r -u ${DB_USERNAME}  -p${PASSWORD} -e 'show databases' -N | \
    grep -Ev "^(mysql|performance_schema|information_schema|sys)$"\
    )

for DB_NAME in ${DB_NAMES}; do
    BACKUP_FILE_NAME="${BACKUP_DIR}/${BACKUP_DATE}.${DB_NAME}.sql.xz"

    /usr/bin/mysqldump \
      -u "${DB_USERNAME}" \
      "-p${PASSWORD}" \
      --databases \
      --add-locks \
      --opt \
      --complete-insert \
      --extended-insert \
      --single-transaction \
      --force \
      --events \
      --routines \
      --triggers \
      --add-drop-database \
      --default-character-set=utf8mb4 "${DB_NAME}" | \
        xz -z -c -T1 -6 > "${BACKUP_FILE_NAME}"

    echo "Backedup ${DB_NAME} to ${BACKUP_FILE_NAME}"
    sleep 5
done
