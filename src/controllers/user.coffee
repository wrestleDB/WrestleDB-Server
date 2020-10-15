User = require '../models/user'
hasher = require '../services/hasher'

class UserController
  register: (req, res) ->
    {username, hashedPassword} = req.body

    unless username?.length > 0 and hashedPassword?.length > 0
      return res.json({error: "User Info Missing"}).status(400).end()

    userAlreadyExists = await User.findOne({username: username})
    if userAlreadyExists
      return res.json({error: 'User Already Exists in Database'}).status(403).end()

    user = new User
      username: username,
      password: hashedPassword

    user.save (error, data) ->
      return res.json(error).status(500).end() if error
      return res.json({}).status(200).end()

  login: (req, res) ->
    console.log "\n\n\nHERE: ", req.body, "\n\n\n"
    {username} = req.body

    unless username?.length > 0
      return res.json({error: "User Info Missing"}).status(400).end()

    user = await User.findOne({username: username})
    console.log "User: ", user

    return res.json({error: "No User Found"}).status(401).end() unless user


    return res.json(user).status(200).end()

  getUser: (req, res) ->
    console.log "CONTROLLER - USER.getUser: ", JSON.stringify(req?.query, null, 2)

    {username} = req.query
    return res.json(error: "No Username supplied").status(400).end() unless username?.length > 0

    user = await User.findOne({username})
    user = { error : "No user found"} unless user

    console.log "user from db: ", JSON.stringify(user, null, 2)

    return res.json(user).status(200).end()

module.exports = ->
  new UserController()