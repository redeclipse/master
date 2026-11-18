#!/bin/sh
date -u
echo "rotating logs"
cd "${HOME}/logs" || exit 1
KEEP=9999 # lines each log keeps
DAYS=90 # days the archive keeps what was cut
mkdir -p archive
day=$(date -u +%Y%m%d)
# cut in place, as the server's tee keeps the file open and appends to it, and would go on writing a removed one;
# lines written while a log is cut can be lost, as they always could
for i in *.log; do
  [ -f "${i}" ] || continue
  echo "processing: ${i}"
  lines=$(wc -l < "${i}")
  [ "${lines}" -gt "${KEEP}" ] || continue
  cut=$((lines - KEEP))
  # each run adds another gzip member to the day's archive, which reads back as one file
  head -n "${cut}" "${i}" | gzip >> "archive/${i%.log}-${day}.log.gz" || continue
  tail -n "+$((cut + 1))" "${i}" > "${i}.tmp" && cat "${i}.tmp" > "${i}"
  rm -f "${i}.tmp"
done
find archive -name '*.log.gz' -type f -mtime "+${DAYS}" -print -delete
echo "done."
cd "${HOME}"
