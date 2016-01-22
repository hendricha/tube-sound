fs = require 'fs'
CSON = require 'cson-parser'
$ = require 'jQuery'

module.exports = class Playlist
  active: null
  filteredIds: []
  __list: []
  __previousSongIds: []
  __nextSongIds: []
  __repeat: false
  __shuffle: false

  constructor: (@$rootScope) ->
    fs.readFile './src/playlist.cson', (err, result) =>
      return err if err
      @__list = CSON.parse result
      @$rootScope.$broadcast 'playlistReloaded'
    @__defineGetter__ 'repeat', => @__repeat
    @__defineSetter__ 'repeat', (val) => @__repeat = val
    @__defineGetter__ 'shuffle', => @__shuffle
    @__defineSetter__ 'shuffle', (val) =>
      @__shuffle = val
      @__previousSongIds = []
      @__nextSongIds = []
    @__defineGetter__ 'list', => @__list.filter (song, id) =>
      @filteredIds.indexOf(id) is -1

    @$rootScope.$on 'addSong', (event, song) =>
      @__list.push song
      @$rootScope.$broadcast 'playlistReloaded'

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

  setFilter: (filter) ->
    @__previousSongIds = []
    @__nextSongIds = []
    @filteredIds = []
    filters = filter.split ' '
    for song, id in @__list
      found = no
      for filter in filters
        if song.title.toLowerCase().indexOf(filter.toLowerCase()) isnt -1
          found = yes
          break
      @filteredIds.push id if not found

    @$rootScope.$broadcast 'playlistReloaded'

  open: (id) ->
    window.gui.Shell.openExternal "https://youtube.com/watch?v=#{@__list[id].YTId}"

  moveUp: (id) ->
    return if id is 0 or @__list.length < 2
    temp = @__list[id]
    @__list[id] = @__list[id - 1]
    @__list[id - 1] = temp
    @$rootScope.$broadcast 'playlistReloaded'

  moveDown: (id) ->
    return if id is @__list.length - 1 or @__list.length < 2
    temp = @__list[id]
    @__list[id] = @__list[id + 1]
    @__list[id + 1] = temp
    @$rootScope.$broadcast 'playlistReloaded'

  remove: (id) -> require('./confirm') 'Are you sure you want to remove this song?', =>
    @__list.splice id, 1
    @$rootScope.$broadcast 'playlistReloaded'
