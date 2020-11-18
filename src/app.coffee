basicAuth       = require 'basic-auth'
compression     = require 'compression'
express         = require 'express'
helmet          = require 'helmet'
morgan          = require 'morgan'
connectDatabase = require('./config/database').connect
setupRoutes     = require './config/routes'
setVariables    = require './config/init'

{createServer}  = require('http')
app             = express()

basicAuthLogins = wrestledb : 'wdb'

################################################################
# Configuration Initialization
################################################################
basicAuthCheck = (req, res, next) ->
  creds = basicAuth(req)
  return res.status(401).send() unless creds and basicAuthLogins[creds.name] is creds.pass
  req.context = {username: creds.name}
  next()

console.log "APP - Setting Environment Variables"
setVariables()

console.log "APP - Configuring Express"
app.set 'port', process.env.PORT or 8081

app.use helmet()

app.use morgan(':method :url :status :response-time ms - :res[content-length]')

app.use compression()

app.use basicAuthCheck
# app.use cors()
app.use express.json()


console.log "APP - Setting up Routes"
setupRoutes(app)

console.log "APP - Connecting to Database"
connectDatabase()

################################################################
# Startup
################################################################
server = createServer(app)
console.log "APP - Starting Server on port", app.get('port')
server.listen app.get('port')

console.log "APP - Server started on port %d in %s mode", app.get('port'), app.settings.env

process.on 'uncaughtException', (err) ->
  console.log "APP - caught an uncaught"
  console.log err
