Controllers = require "../controllers"

module.exports = (app) ->
  app.post '/login', (req, res) ->
    console.log "ROUTES - Login"
    Controllers.User().login req, res

  app.post '/register', (req, res) ->
    console.log "ROUTES - Register"
    Controllers.User().register req, res

  app.get '/user', (req, res) ->
    console.log "ROUTES - Register"
    Controllers.User().getUser req, res

  app.get '/wrestlers', (req, res) ->
    console.log "loading wrestlers route"
    Controllers.Wrestler().info req, res

  app.get '/tournaments', (req, res) ->
    console.log "loading tournaments route"
    Controllers.Tournament().getTournaments req, res

  app.put '/tournaments', (req, res) ->
    console.log "ROUTES - put to tournaments route, req.params: ", req
    Controllers.Tournament().addTournament req, res