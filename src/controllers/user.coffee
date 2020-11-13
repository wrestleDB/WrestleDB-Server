User = require '../models/user'
hasher = require '../services/hasher'

class UserController
  register: (req, res) ->
    console.log "\n\n\nRegister - HERE: ", req.body, "\n\n\n"
    {username, email, hashedPassword} = req.body

    username = email unless username

    unless username?.length > 0 and hashedPassword?.length > 0
      return res.json({error: "User Info Missing"}).status(400).end()

    userAlreadyExists = await User.findOne({username: username})
    console.log "user Already Exists: ", JSON.stringify(userAlreadyExists, null, 2)
    if userAlreadyExists
      return res.json({error: 'User Already Exists in Database'}).status(403).end()

    user = new User
      username: username,
      password: hashedPassword

    user.save (error, data) ->
      console.log "User Saved!!", JSON.stringify data, null, 2
      console.log "User Saved!ERROR!", JSON.stringify error, null, 2
      return res.json(error).status(500).end() if error
      return res.json(data).status(200).end()

  login: (req, res) ->
    console.log "\n\n\nLOGIN - HERE: ", req.body, "\n\n\n"
    {username, email} = req.body

    username = email unless username

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