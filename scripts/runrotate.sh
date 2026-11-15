#!/bin/sh
date -u
echo "rotating logs"
cd "${HOME}/logs" || exit 1
# cut in place, as the server's tee keeps the file open and appends to it, and would go on writing a removed one
for i in *.log; do
  [ -f "${i}" ] || continue
  echo "processing: ${i}"
  tail -n 9999 "${i}" > "${i}.tmp" && cat "${i}.tmp" > "${i}"
  rm -f "${i}.tmp"
done
echo "done."
cd "${HOME}"
