Tournament = require '../models/tournament'
# WrestlerRater = '../services/rater/wrestler_rater'

class TournamentController
  getTournaments: (req, res) ->
    console.log "CONTROLLER - TOURNAMENT.info request: ", JSON.stringify(req?.query, null, 2)
    tournaments = await Tournament.find()

    console.log "list of tournaments: ", JSON.stringify(tournaments, null, 2)

    if false
      res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "tournament info missing"})
      res.end()
      return

    res.writeHead 200, {"Content-Type" : "application/json", "connection" : "keep-alive"}
    res.write JSON.stringify(tournaments)
    res.end()

  addTournament: (req, res) ->
    console.log "CONTROLLER - TOURNAMENT.addTournament request: ", req.body.tournament
    unless req.body?.tournament?.length > 0
      res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "tournament info missing"})
      res.end()
      return

    tournament = new Tournament(JSON.parse(req.body.tournament))
    console.log "MODEL - Tournament: ", JSON.stringify(tournament, null, 2)

    tournament.save (err, data) =>
      if err
        res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
        res.write JSON.stringify({"error" : "tournament info missing"})
        res.end()
        return
      else
        res.writeHead 200, {"Content-Type" : "application/json", "connection" : "keep-alive"}
        res.write JSON.stringify(tournament)
        res.end()

module.exports = ->
  new TournamentController()