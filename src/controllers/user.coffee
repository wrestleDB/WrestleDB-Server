User = require '../models/user'


class UserController
  getUser: (req, res) ->
    console.log "CONTROLLER - USER.getUser: ", JSON.stringify(req?.query, null, 2)
    user = await User.findById(req.query.userId)

    console.log "user from db: ", JSON.stringify(user, null, 2)

    if false
      res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "userId missing"})
      res.end()
      return

    res.writeHead 200, {"Content-Type" : "application/json", "connection" : "keep-alive"}
    res.write JSON.stringify(user)
    res.end()

  addUser: (req, res) ->
    console.log "CONTROLLER - USER.addUser: ", req.body.user
    unless req.body?.user?.length > 0
      res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
      res.write JSON.stringify({"error" : "User info missing"})
      res.end()
      return

    user = new User(JSON.parse(req.body.user))
    console.log "MODEL - User: ", JSON.stringify(user, null, 2)

    user.save (err, data) =>
      if err
        res.writeHead 500, {"Content-Type" : "application/json", "connection" : "keep-alive"}
        res.write JSON.stringify({"error" : "user save failed"})
        res.end()
      else
        res.writeHead 200, {"Content-Type" : "application/json", "connection" : "keep-alive"}
        res.write JSON.stringify(user)
        res.end()

module.exports = ->
  new UserController()