$ = require 'jQuery'

modal = $()
card = $()

__cb = ->
__$scope = {}

module.exports = (message, cb) ->
  __cb = cb
  modal.fadeIn()
  __$scope.message = message
  #__$scope.$evalAsync()


module.exports.controller = ($scope, $rootScope) ->
  __$scope = $scope
  modal = $('.ui.confirm.modal')
  modal.hide()

  $scope.message = ''

  $scope.cancel = ->
    modal.hide()
    return

  $scope.approve = ->
    modal.hide()
    __cb()
    return
