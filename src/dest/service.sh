#!/usr/bin/env sh
#
# Aria2 service

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="aria2"
version="1.17.1"
description="HTTP/FTP download manager"
depends=""
webui=":6880/"

prog_dir="$(dirname "$(realpath "${0}")")"
daemon="${prog_dir}/bin/aria2c"
conffile="${prog_dir}/etc/aria2.conf"
sessionfile="${prog_dir}/var/aria2.session"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"
nicelevel=19

webserver="${prog_dir}/libexec/web_server"
confweb="${prog_dir}/etc/web_server.conf"
pidweb="/tmp/DroboApps/${name}/web_server.pid"

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  framework_version="2.0"
  . "${prog_dir}/libexec/service.subr"
fi

_create_session() {
  local sessiondir="$(dirname ${sessionfile})"
  if [ ! -d "${sessiondir}" ]; then mkdir -p "${sessiondir}"; fi
  if [ ! -f "${sessionfile}" ]; then touch "${sessionfile}"; fi
}

start() {
  _create_session
  export HOME="${prog_dir}/var"
  "${daemon}" --conf-path="${conffile}" --daemon=true
  echo $(pidof $(basename "${daemon}")) > "${pidfile}"
  renice "${nicelevel}" $(cat "${pidfile}")
  if ! is_running "${pidweb}" "${webserver}"; then
    "${webserver}" "${confweb}" & echo $! > "${pidweb}"
    renice "${nicelevel}" $(cat "${pidweb}")
  fi
}

stop() {
  /sbin/start-stop-daemon -K -x "${webserver}" -p "${pidweb}" -v -o
  /sbin/start-stop-daemon -K -x "${daemon}" -p "${pidfile}" -v
}

force_stop() {
  /sbin/start-stop-daemon -K -s 9 -x "${webserver}" -p "${pidweb}" -v -o
  /sbin/start-stop-daemon -K -s 9 -x "${daemon}" -p "${pidfile}" -v
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o pipefail # propagate last error code on pipe
set -o xtrace   # enable script tracing

main "${@}"
