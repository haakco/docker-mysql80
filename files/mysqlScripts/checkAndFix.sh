#!/usr/bin/env bash
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

mysqlcheck --all-databases --check --auto-repair --extended --force -u "${DB_USERNAME}" -p"${PASSWORD}"
mysqlcheck --all-databases --optimize -u "${DB_USERNAME}" -p"${PASSWORD}"
mysqlcheck --all-databases --analyze -u "${DB_USERNAME}" -p"${PASSWORD}"

#find /var/lib/mysql -name '*.MYI' -exec myisamchk --silent --fast '{}' \;
