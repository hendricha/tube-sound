module.exports = {}
module.exports.__defineGetter__ 'list', ->
  window.localStorage.playlist = JSON.stringify [] if not window.localStorage.playlist?
  JSON.parse window.localStorage.playlist

module.exports.__defineSetter__ 'list', (list) ->
  delete item.$$hashKey for item in list when item.$$hashKey?
  window.localStorage.playlist = JSON.stringify list
