$ = require 'jQuery'
youtubeVideo = require 'youtube-video'
calculateTime = require './calculateTime'
urlParser = require 'url'

modal = $()
card = $()

module.exports = ($scope, $rootScope) ->
  modal = $('.ui.add.modal')
  card = $('.ui.card')
  song = {}
  modal.hide()
  $rootScope.$on 'requestToggleAdd', ->
    card.hide()
    modal.fadeToggle()
  $scope.hide = -> modal.fadeOut()
  $scope.state = 'idle'
  $scope.error = no
  $scope.addable = no
  $scope.url = ''
  $scope.title = ''
  $scope.yTId = ''
  $scope.length = ''
  $scope.fetchData = =>
    @state = 'loading'
    $scope.$evalAsync()
    song = YTId: urlParser.parse($scope.url, yes).query.v
    $scope.yTId = song.YTId
    youtubeVideo song.YTId, {autoplay: no}, (err, player) ->
      if err or not song.YTId
        card.slideUp()
        $scope.error = yes
        $scope.$evalAsync()
        return console.log err

      $scope.error = no
      $scope.addable = yes
      @state = 'idle'
      $scope.title = song.title = player.getVideoData().title
      $scope.length = song.length = calculateTime player.getDuration()
      card.slideDown()
      $scope.$evalAsync()

  $scope.add = =>
    $scope.addable = no
    $scope.hide()
    $rootScope.$broadcast 'addSong', song
    $scope.$evalAsync()
