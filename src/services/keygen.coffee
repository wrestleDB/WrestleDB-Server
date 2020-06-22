hat = require 'hat'

module.exports = ->
   new Date().getTime().toString(16) + hat()
