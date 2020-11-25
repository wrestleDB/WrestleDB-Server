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

  getTournament: (req, res) ->
    event = await Tournament.findById(req.params.id) if req.params.id

    return res.json({error: "no ID passed in"}).status(400).end() unless req.params.id
    return res.json({error: "No event found for eventId: #{req.params.id}"}).status(400).end() unless event

    return res.json(event).status(200).end()


  addTournament: (req, res) ->
    console.log "CONTROLLER - TOURNAMENT.addTournament request: ", req.body
    console.log "CHECK HERE: ", req.body
    unless req.body
      res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "tournament info missing"})
      res.end()
      return

    tournament = new Tournament(req.body)
    console.log "MODEL - Tournament: ", JSON.stringify(tournament, null, 2)
    tournament.save (err, data) =>
      if err
        console.log "ERR: ", err
        res.json({error: err}).status(500).end()

      else
        console.log "SuccessFUL Save", {tournament, data}
        res.json(tournament).status(201).end()
        # res.writeHead 200, {"Content-Type" : "application/json", "connection" : "keep-alive"}
        # res.write JSON.stringify(tournament)
        # res.end()

module.exports = ->
  new TournamentController()