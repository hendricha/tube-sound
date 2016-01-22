fs = require 'fs'
$ = require 'jQuery'
youtubeVideo = require 'youtube-video'
window = global.window.nwDispatcher.requireNwGui().Window.get()
Playlist = require './playlist'

module.exports = (angular, document) ->
  global.document = document

  player = angular.module 'player', []

  player.controller 'controlsController', ($scope, $rootScope) ->
    setState = (state) ->
      $scope.state = state
      $scope.$evalAsync()

    videoPlayer = null
    durationInterval = null
    videoPlayerOptions =
      selector: true
      elementId: 'videoPlayer'
      width: 1
      height: 1
      autoplay: true
      onPlay: -> setState 'playing'
      onPause: -> setState 'paused'
      onEnd: -> $scope.next()

    $scope.state = 'paused'
    $scope.shuffle = no
    $scope.repeat = no
    $scope.videoLength = 0
    $scope.timeElapsed = 0
    $scope.progress = 0
    $scope.filter = ''

    $scope.toggleAdd = ->
      $rootScope.$broadcast 'requestToggleAdd'

    $scope.toggleShuffle = ->
      $scope.shuffle = not $scope.shuffle
      $rootScope.$broadcast 'requestShuffleChange', $scope.shuffle
    $scope.toggleRepeat = ->
      $scope.repeat = not $scope.repeat
      $rootScope.$broadcast 'requestRepeatChange', $scope.repeat

    $scope.calculateTime = require './calculateTime'

    setProgress = (progress) ->
      $('.progress .bar').css width: "#{progress * 100}%"

    $rootScope.$on 'selectedSong', (event, song) ->
      window.title = song.title
      setState 'loading'
      $('#videoPlayer').remove()
      $('#controls').append '<div id="videoPlayer"></div>'
      youtubeVideo song.YTId, videoPlayerOptions, (err, player) ->
        return console.log err if err
        $scope.videoLength = player.getDuration()
        durationInterval = setInterval ->
          $scope.timeElapsed = videoPlayer.getCurrentTime()
          setProgress $scope.timeElapsed / $scope.videoLength
          $scope.$apply()
        , 100

        videoPlayer = player

    $scope.jump = ($event) ->
      videoPlayer?.seekTo parseInt $event.pageX / $(document).width() * $scope.videoLength

    $scope.playPause = ->
      switch $scope.state
        when 'paused' then videoPlayer?.playVideo()
        when 'playing' then videoPlayer?.pauseVideo()

    $scope.add = require './add'
    $scope.previous = -> $rootScope.$broadcast 'requestPreviousSong'
    $scope.next = -> $rootScope.$broadcast 'requestNextSong'

    $scope.setFilter = -> $rootScope.$broadcast 'requestFilter', $scope.filter

  player.controller 'playlistController', ($scope, $rootScope) ->
    $scope.playlist = new Playlist $rootScope

    $rootScope.$on 'playlistReloaded', -> $scope.$evalAsync()

    $rootScope.$on 'requestPreviousSong', -> $scope.playlist.playPreviousSong()

    $rootScope.$on 'requestNextSong', -> $scope.playlist.playNextSong()

    $rootScope.$on 'requestRepeatChange', (event, repeat) ->
      $scope.playlist.repeat = repeat

    $rootScope.$on 'requestShuffleChange', (event, shuffle) ->
      $scope.playlist.shuffle = shuffle

    $rootScope.$on 'requestFilter', (event, filter) ->
      $scope.playlist.setFilter filter

  player.controller 'addController', require './add'

  player.controller 'confirmController', require('./confirm').controller
