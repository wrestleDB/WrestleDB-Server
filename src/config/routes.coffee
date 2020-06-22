Controllers = require "../controllers"

module.exports = (app) ->
  app.get '/wrestlers', (req, res) ->
    console.log "loading wrestlers route"
    Controllers.Wrestler().info req, res

  app.post '/authenticate', (req, res) ->
    console.log "loading authentication route"
    Controllers.Authenticate().info req, res