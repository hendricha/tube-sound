module.exports = (seconds) ->
  minutes = parseInt seconds / 60
  seconds = parseInt(seconds - minutes * 60).toString()
  if seconds.length is 1 then seconds = "0#{seconds}"
  "#{minutes}:#{seconds}"
