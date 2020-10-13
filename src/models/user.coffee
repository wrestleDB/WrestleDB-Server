mongoose       = require 'mongoose'
hasher         = require '../services/hasher'
keygen         = require '../services/keygen'

UserSchema = new mongoose.Schema
  username      : String
  password      : String
  apiKey        : type: String, default: keygen
  created       : type: Date, default: Date.now
  registered    : type: Date, default: null
  firstName     : String
  lastName      : String

UserSchema.set 'toJSON', {getters : true} # output the virtual getters when calling toJSON

# Virtuals ---------------------------------------------------------------------

UserSchema.virtual('fullName').get ->
  name = "#{@firstName or ''} #{@lastName or ''}".trim()
  unless name.length then name = @username
  name

UserSchema.virtual('email').get ->
  @username

# Methods ----------------------------------------------------------------------

#sets this instance password and calls back with the resulting hashed password; does not save!
UserSchema.methods.setPassword = (password, cb) ->
  console.log "About to Hash Password: ", password
  hasher.hash password, (err, result) =>
    console.log "result: ", result
    if err then return cb err
    @password = result
    cb null, @password

#compare passwords
UserSchema.methods.checkPassword = (password, done) ->
  console.log "password check", password, @password
  hasher.compare password, @password, done

module.exports = mongoose.model 'users', UserSchema
module.exports.Schema = UserSchema