#!/usr/bin/env sh
#
# update script

prog_dir="$(dirname "$(realpath "${0}")")"
name="$(basename "${prog_dir}")"
tmp_dir="/tmp/DroboApps/${name}"
logfile="${tmp_dir}/update.log"

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

/bin/sh "${prog_dir}/service.sh" stop

if [ -f "${prog_dir}/etc/aria2.conf" ]; then
  if grep -q "log=${tmp_dir}/log.txt" "${prog_dir}/etc/aria2.conf"; then
    sed -e "s|log=${tmp_dir}/log.txt|log=${tmp_dir}/aria2.log|g" -i "${prog_dir}/etc/aria2.conf"
  fi
fi
