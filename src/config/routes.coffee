Controllers = require "../controllers"

module.exports = (app) ->
  app.get '/wrestlers', (req, res) ->
    Controllers.Wrestler().info req, res