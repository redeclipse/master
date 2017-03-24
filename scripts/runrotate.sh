#!/bin/bash
date -u
echo "rotating logs"
pushd "${HOME}/logs"
for i in *.log; do
  echo "processing: ${i}"
  tail -n 9999 "${i}" > "${i}.tmp"
  rm "${i}"
  mv "${i}.tmp" "${i}"
done
popd
echo "done."
