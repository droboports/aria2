#!/usr/bin/env sh
#
# Aria2 service

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="aria2"
version="1.17.1-2"
description="The next generation download utility"
depends=""
webui="WebUI"

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

apachedaemon="${DROBOAPPS_DIR}/apache/service.sh"
appconffile="${prog_dir}/etc/aria2app.conf"
apachefile="${DROBOAPPS_DIR}/apache/conf/includes/aria2app.conf"

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
  cp -vf "${appconffile}" "${apachefile}"
  "${apachedaemon}" restart || true
}

stop() {
  rm -vf "${apachefile}"
  "${apachedaemon}" restart || true
  /sbin/start-stop-daemon -K -x "${daemon}" -p "${pidfile}" -v
}

force_stop() {
  rm -vf "${apachefile}"
  "${apachedaemon}" restart || true
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
set -o xtrace   # enable script tracing

main "${@}"
