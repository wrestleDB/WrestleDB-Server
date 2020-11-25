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

  app.post '/tournaments', (req, res) ->
    console.log "ROUTES - post to tournaments route, req.params: ", req.body
    Controllers.Tournament().addTournament req, res

  app.get '/event/:id', (req, res) ->
    console.log "loading tournaments route:", req.params
    Controllers.Tournament().getTournament req, res