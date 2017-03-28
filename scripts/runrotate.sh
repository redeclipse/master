#!/bin/sh
date -u
echo "rotating logs"
cd "${HOME}/logs"
for i in *.log; do
  echo "processing: ${i}"
  tail -n 9999 "${i}" > "${i}.tmp"
  rm "${i}"
  mv "${i}.tmp" "${i}"
done
echo "done."
cd "${HOME}"
