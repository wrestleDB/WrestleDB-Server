Wrestler = require '../models/wrestler'
# WrestlerRater = '../services/rater/wrestler_rater'

class WrestlerController
  info: (req, res) ->
    console.log "CONTROLLER - WRESTLER.info request: ", JSON.stringify(req?.query, null, 2)
    wrestlers = await Wrestler.find()
    if false
      res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "wrestler info missing"})
      res.end()
      return

    res.writeHead 200, {"Content-Type" : "application/json", "connection" : "keep-alive"}
    res.write JSON.stringify(wrestlers)
    res.end()

module.exports = ->
  new WrestlerController()