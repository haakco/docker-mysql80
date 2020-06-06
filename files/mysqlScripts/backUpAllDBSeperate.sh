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


BACKUP_DATE=$(date +"%Y%m%d%H%M")
BACKUP_DIR="/backup/seperate/${BACKUP_DATE}"

rm -rf "${BACKUP_DIR:?}/*"

mkdir -p "${BACKUP_DIR}"

DB_NAMES=$(\
    mysql -s -r -u ${USERNAME}  -p${PASSWORD} -e 'show databases' -N | \
    grep -Ev "^(mysql|performance_schema|information_schema|sys)$"\
    )

for DB_NAME in ${DB_NAMES}; do
    BACKUP_FILE_NAME="${BACKUP_DIR}/${BACKUP_DATE}.${DB_NAME}.sql.xz"

    echo /usr/bin/mysqldump \
      -u "${USERNAME}" \
      "-p${PASSWORD}" \
      --add-locks \
      --opt \
      --complete-insert \
      --extended-insert \
      --single-transaction \
      --force \
      --add-drop-database \
      --default-character-set=utf8mb4 "${DB_NAME}" | \
        xz -z -c -T0 -9e > "${BACKUP_FILE_NAME}"

    echo "Backedup ${DB_NAME} to ${BACKUP_FILE_NAME}"
    sleep 5
done
