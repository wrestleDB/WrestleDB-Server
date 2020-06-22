global.express  = require "express"
global.app      = express()
auth            = require './services/authenticate'
connectDatabase = require('./config/database').connect
setupExpress    = require './config/express'
setupRoutes     = require './config/routes'
setVariables    = require './config/init'
server          = require('http').createServer(app)

################################################################
# Configuration Initialization
################################################################
console.log "APP - Setting Environment Variables"
setVariables()

console.log "APP - Configuring Express"
setupExpress()

# initalize authentication middleware (passport)
# This should be after static file (so auth lookups only happen on route requests), and it must
# be before app.router so auth is loaded before routes are loaded.

# auth.init app

console.log "APP - Setting up Routes"
setupRoutes(app)

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
