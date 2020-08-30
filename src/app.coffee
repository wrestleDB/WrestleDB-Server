global.express  = require "express"
global.app      = express()
authenticate    = require './services/authenticate'
connectDatabase = require('./config/database').connect
setupExpress    = require './config/express'
setRoutes       = require './config/routes'
setVariables    = require './config/init'
server          = require('http').createServer(app)

################################################################
# Configuration Initialization
################################################################
console.log "APP - Setting Environment Variables"
setVariables()

console.log "APP - Configuring Express"
setupExpress()

console.log "APP - Authenticating"
# This should be after static file (so auth lookups only happen on route requests)
authenticate.init app
# And it must be before setRoutes so auth is loaded before routes are loaded.

console.log "APP - Setting up Routes"
setRoutes(app)

console.log "APP - Connecting to Database"
connectDatabase()

################################################################
# Startup
################################################################
console.log "APP - Starting Server on port", app.get('port')
server.listen app.get('port')

console.log "APP - Server started on port %d in %s mode", app.get('port'), app.settings.env

process.on 'uncaughtException', (err) ->
  console.log "APP - caught an uncaught"
  console.err err
