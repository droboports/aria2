angular
.module('webui.services.configuration',  [])
.constant('$name', 'Aria2 WebUI')
.constant('$titlePattern', 'active: {active} - waiting: {waiting} - stopped: {stopped} — {name}')
.constant('$pageSize', 11)
.constant('$authconf', {
  host: 'localhost',
  port: 6800,
  encrypt: false,
  auth: {
  // token: '$YOUR_SECRET_TOKEN$'
  /*-----------------------------*/
  // user: '*YOUR_USERNAME*',
  // pass: '*YOUR_SECRET_PASS*'
  },
  directURL: ''
})
.constant('$enable', {
  torrent: true,
  metalink: true,
  sidebar: {
    show: true,
    stats: true,
    filters: true,
    starredProps: true
  }
})
.constant('$starredProps', [
  'dir', 'max-concurrent-downloads', 'max-connection-per-server', 'max-overall-download-limit', 'max-overall-upload-limit', 'conf-path'
])
.constant('$downloadProps', [
  'dir', 'pause', 'max-download-limit', 'max-upload-limit', 'max-connection-per-server'
])
.constant('$globalTimeout', 1000)
;
