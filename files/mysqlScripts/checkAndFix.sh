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

mysqlcheck -h 127.0.0.1 --all-databases --check --auto-repair --force -u "${USERNAME}" -p"${PASSWORD}"
mysqlcheck -h 127.0.0.1 --all-databases --optimize --force -u "${USERNAME}" -p"${PASSWORD}"

#find /var/lib/mysql -name '*.MYI' -exec myisamchk --silent --fast '{}' \;
