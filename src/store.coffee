module.exports = {}
module.exports.__defineGetter__ 'list', ->
  window.localStorage.playlist = JSON.stringify [] if not window.localStorage.playlist?
  JSON.parse window.localStorage.playlist
module.exports.__defineSetter__ 'list', (val) ->
  window.localStorage.playlist = JSON.stringify val
