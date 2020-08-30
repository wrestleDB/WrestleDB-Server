_ = require 'lodash'
fs = require 'fs'
http = require 'http'
path = require 'path'
util = require 'util'

User = require '../models/user'
# WrestlerRater = '../services/rater/wrestler_rater'

class UserController
  info: (req, res) ->
    console.log "CONTROLLER:user - info request: ", JSON.stringify(req?.query, null, 2)
    user = await User.find()

    if false
      res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "wrestler info missing"})
      res.end()
      return

    res.writeHead 200, {"Content-Type" : "application/json", "connection" : "keep-alive"}
    res.write JSON.stringify(user)
    res.end()

module.exports = ->
  new UserController()