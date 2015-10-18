fs = require 'fs'
CSON = require 'cson-parser'

module.exports = class Playlist
  active: null
  list: []
  __previousSongIds: []
  __nextSongIds: []
  __repeat: false
  __shuffle: false

  constructor: (@$rootScope) ->
    fs.readFile './src/playlist.cson', (err, result) =>
      return err if err
      @list = CSON.parse result
      @$rootScope.$broadcast 'playlistReloaded'
    @__defineGetter__ 'repeat', => @__repeat
    @__defineSetter__ 'repeat', (val) => @__repeat = val
    @__defineGetter__ 'shuffle', => @__shuffle
    @__defineSetter__ 'shuffle', (val) =>
      @__shuffle = val
      @__previousSongIds = []
      @__nextSongIds = []

  __selectSong: (id) ->
    @active = parseInt id
    @$rootScope.$broadcast 'selectedSong', @list[id]

  getRandomId: ->
    randomId = Math.floor Math.random() * (@list.length - 1)

    return if randomId >= @active then randomId + 1 else randomId

  playSong: (id) ->
    @__nextSongIds = []
    @__selectSong id

  playPreviousSong: ->
    currentId = switch
      when @__previousSongIds.length then @__previousSongIds.pop()
      when @shuffle then @getRandomId()
      else @active - 1
    if currentId < 0
      return if not @repeat
      currentId =  1

    @__nextSongIds.unshift @active

    @__selectSong currentId

  playNextSong: ->
    currentId = switch
      when @__nextSongIds.length then @__nextSongIds.shift()
      when @shuffle then @getRandomId()
      else @active + 1
    if currentId >= @list.length
      return if not @repeat
      currentId = 0

    @__previousSongIds.push @active

    @__selectSong currentId
