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

export OPTIMIZE="";
mysql -u "${USERNAME}" -p"${PASSWORD}" -NBe "SHOW DATABASES;" | grep -v 'lost+found' | while read database ; do
  mysql -h 127.0.0.1 -u "${USERNAME}" -p"${PASSWORD}" -NBe "SHOW TABLE STATUS;" $database | while read name engine version rowformat rows avgrowlength datalength maxdatalength indexlength datafree autoincrement createtime updatetime checktime collation checksum createoptions comment ; do
    if [ "$datafree" -gt 0 ] ; then
      fragmentation=$(($datafree * 100 / $datalength))
      echo "$database.$name is $fragmentation% fragmented"
      OPTIMIZE=${OPTIMIZE}"\nOPTIMIZE TABLE ${name};";
      echo ${OPTIMIZE};
#      echo -n "Should we optimize [y/n]: " ; read checkOptimize ; stty echo ; echo
#      if [ "${checkOptimize}" = "y" ]
#      then
#        mysql -u "${USERNAME}" -p"${PASSWORD}" -NBe "OPTIMIZE TABLE $name;" "$database"
#      fi
    fi
  done
done
