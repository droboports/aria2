angular
.module('webui.services.configuration',  [])
.constant('$name', 'webui-aria2')
.constant('$pageSize', 11)
.constant('$authconf', {
  host: 'localhost',
  port: 6800,
  encrypt: false,
  auth: {}
})
.constant('$enable', {
  torrent: true,
  metalink: true,
  sidebar: {
    show: true,
    stats: true,
    filters: true,
    starredProps: true,
  }
})
.constant('$starredProps', [
  'dir', 'max-concurrent-downloads', 'max-connection-per-server', 'max-overall-download-limit', 'max-overall-upload-limit', 'conf-path',
])
.constant('$downloadProps', [
  'dir', 'pause', 'max-download-limit', 'max-upload-limit', 'max-connection-per-server'
])
.constant('$globalTimeout', 1000)
;


