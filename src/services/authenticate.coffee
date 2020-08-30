User = require '../models/user'
passport      = require 'passport'
LocalStrategy = require('passport-local').Strategy

class Authentication

  init: (@app) ->
    console.log "AUTHENTICATION - Constructing the authentication class"
    passport.use @authStrategy()
    console.log "AUTHENTICATION - Constructing the au"
    passport.serializeUser @serializeUser
    passport.deserializeUser @deserializeUser
    @app.use passport.initialize()
    @app.use passport.session()
    @app.use @setContext

  authStrategy: ->
    console.log "AUTHENTICATION - Starting auth strategy"

    new LocalStrategy (username, password, done) ->
      console.log "username: 0", username
      username = username?.toLowerCase().trim() or ''

      return done(null, false) unless username

      User.findOne {username: username}, (err, account, user) ->
        return done(err, false) if err?
        console.log "AUTHENTICATION - Found Account: ", JSON.stringify(account, null, 2)
        console.log "AUTHENTICATION - Found User: ", JSON.stringify(user, null, 2)

        # return done(null, false, "<p>Cannot login at this time. Please contact support.</p>") if account.disabled
        # return done(null, false) if user.removed

        # if process.env.NODE_ENV is "staging"
        #   if not account.isAdmin() and (process.env.WHITELISTED_ACCOUNTS and process.env.WHITELISTED_ACCOUNTS.indexOf(account.id) is -1)
        #     return done(null, false, "<p>Please use our production environment at <a href=\"https://www.freightview.com\">www.freightview.com</a></p>")
        console.log "AUTHENTICATION - About to check password"
        user.checkPassword password, (err, result) ->
          return done(err, null) if err? or not result

          Account.findAndUpdateLogin user.username, (err, account, user) ->
            logger.log err, ['passport', 'last-login'] if err?
            done null, {account: account, user: user}, null

  serializeUser: (user, done) ->
    done null, user.username

  deserializeUser: (username, done) ->
    console.log "deserializeUser: ", username
    User.findOne {username: username}, (err, account, user) ->
      context =
        user: user
        account: account
      done err, context


  # MIDDLEWARE -----------------------------------------------------------------
  setContext: (req, res, next) ->
    console.log "setting context"
    return next() unless req.user?.user?
    console.log "req.user: ", JSON.stringify(req.user, null, 2)
    req.context = req.user
    delete req.user
    next()
    # req.context.hasPermission = (permission) -> req.context.user.hasPermission permission
    # req.context.isAdmin = false
    # req.session.passport.rootUser ?= req.context.user.username
    # if req.session.passport.rootUser is req.context.user.username
    #   req.context.rootUser = req.context.user
    #   req.context.isAdmin = req.context.account?.isAdmin() is true
    #   next()
    # else
    #   Account.findByUsername req.session.passport.rootUser, (err, account, user) ->
    #     return next(err) if err?
    #     if not account? or not user? or account.isAdmin() isnt true
    #       logger.log new Error("Non-admin root user #{req.session.passport.rootUser} does not have access to view as #{req.context.user.username}"), ['view-as', 'error']
    #       delete req.context
    #       next()
    #     else
    #       req.context.rootUser = user
    #       req.context.isAdmin = account?.isAdmin() is true
    #       next()
  login: (req, res, next) ->
    delete req.session.passport.rootUser if req.session?.passport?.rootUser
    delete req.context.rootUser if req.context?.rootUser
    passport.authenticate('local', (err, context, info) ->

      return next(err) if err?
      unless context?.account? and context?.user?
        res.locals.loginResponse =
          success: false
          message: info or '<p>The username or password you entered is incorrect.</p>'
        return next()
      req.login context.user, (err) ->
        return next(err) if err?
        logger.logEventForUser "Logged in", context.account.toEventObj(), context.user, context.account
        req.session.cookie.maxAge = 2592000000 #30*24*60*60*1000 Rememeber 'me' for 30 days
        res.cookie 'landing', landing.signupVariant, {maxAge: 31536000000, httpOnly: false}
        resp = {success: true}
        if req.body.redirectTo
          resp.redirectTo = req.body.redirectTo
        res.locals.loginResponse = resp
        next()
    )(req, res, next)

  logout: (req, res, next) ->
    req.logout()
    delete req.context
    req.session.destroy()
    next()


module.exports = new Authentication()