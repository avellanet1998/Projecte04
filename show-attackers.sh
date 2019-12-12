#!/bin/bash

readonly MAX = "10"
Fitxer ="${1}"

#Verifiquem que existeixi volquem els errors
if [ ! -e "${Fitxer}" ]; then
    echo "No es pot obrir el fitxer ${Fitxer}" >&2
    exit 1
fi

#imprimeixo el header de CSV
echo "Count,IP,Location"


#Bucle sobre la llista de fallos
grep Failed syslog-sample | awk "{print $(NF - 3)}" | sort | uniq -c | sort -nr | while read COUNT IP; do
  if [ "${COUNT}" -gt "${MAX}" ]; then
      Location=$(geoiplookup "${IP}" | awk -F ", " "{print $2}")
      echo "${COUNT},${IP},${LOCATION}"
  fi
done

exit 0
