_ = require 'lodash'
fs = require 'fs'
http = require 'http'
path = require 'path'
util = require 'util'



User = require '../models/user'
# WrestlerRater = '../services/rater/wrestler_rater'

class Authenticate
  info: (req, res) ->
    {username, password} = req.body
    console.log "CONTROLLER:authenticate - authenticate request: ", JSON.stringify(req.body, null, 2)

    # passport.authenticate 'local', {
    #   successRedirect : '/'
    #   failureRedirect: '/login'
    #   failureFlash: true
    # }

    if username and password
      console.log "CONTROLLER:authenticate - has Username and password!!!"

    unless username and password
      console.log "CONTROLLER:authenticate - no username and/or password entered"
      res.writeHead 401, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "No username provided"}) unless username
      res.write JSON.stringify({"error" : "No password provided"}) unless password
      return res.end()

    console.log "CONTROLLER:authenticate - Username: ", JSON.stringify(username, null, 2)
    user = await User.findOne({email: username}, {username: 1, password: 1})

    unless user
      console.log "CONTROLLER:authenticate - no user found"
      res.writeHead 401, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "No user found"})
      return res.end()

    console.log "CONTROLLER:authenticate - comparing passwords do they match?: ", password is user.password
    unless password is user.password
      console.log "CONTROLLER:authenticate - no user found"
      res.writeHead 401, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "Invalid Username/password "})
      return res.end()

    console.log "CONTROLLER:authenticate - Found User: ", JSON.stringify(user, null, 2)
    res.writeHead 200, {"Content-Type" : "application/json", "connection" : "keep-alive"}
    res.write JSON.stringify token: "testing_token"
    res.end()

module.exports = ->
  new Authenticate()