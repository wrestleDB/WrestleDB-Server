mongoose       = require 'mongoose'
hasher         = require '../services/hasher'
constants      = require '../services/constants'
keygen         = require '../services/keygen'

# Schema -----------------------------------------------------------------------

UserSchema = new mongoose.Schema
  username      : type: String
  password      : String
  apiKey        : type: String, default: keygen
  created       : type: Date, default: Date.now
  registered    : type: Date, default: null
  firstName     : String
  middleName    : String
  lastName      : String
  suffix        : String
  phone         : String
  preferences   : Object
  parentId      : type: Object, default: null
  coachId       : type: Object, default: null
  refereeId     : type: Object, default: null
  permissions   : type: [String], enum: constants.userPermissions, default: ['free', 'basic', 'advanced']
  recover:
    code    : type: String
    date    : Date
    expires : Date
  direct:
    code    : type: String
    date    : Date
    expires : Date
  lastLogin : Date
  crm:
    id : String
  marketing:
    subscribed: type: Boolean, default: true

# output the virtual getters when calling toJSON
UserSchema.set 'toJSON', {getters : true}

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
  hasher.hash password, (err, result) =>
    if err then return cb err
    @password = result
    cb null, @password

#compare passwords
UserSchema.methods.checkPassword = (password, done) ->
  hasher.compare password, @password, done

UserSchema.methods.hasPermission = (permission) ->
  return true if @owner
  return true if @permissions?.indexOf(permission) >= 0
  return false

UserSchema.methods.toPublicObj = ->
  tmp = @.toJSON()
  _id            : tmp.id
  username       : tmp.username
  firstName      : tmp.firstName
  lastName       : tmp.lastName
  fullName       : tmp.fullName
  title          : tmp.title
  phone          : tmp.phone
  preferences    : tmp.preferences or {}
  created        : tmp.created
  registered     : tmp.registered
  lastLogin      : tmp.lastLogin
  owner          : tmp.owner
  permissions    : tmp.permissions
  stats          : tmp.stats
  recent         : tmp.recent
  marketing      : tmp.marketing
  rate_modifier  : tmp.rate_modifier
  savedViews     : tmp.savedViews

# Exports ----------------------------------------------------------------------

module.exports = mongoose.model 'users', UserSchema
module.exports.Schema = UserSchema





# AccountUserSchema = new mongoose.Schema
#   username      : type: String
#   password      : String
#   apiKey        : type: String, default: keygen
#   created       : type: Date, default: Date.now
#   registered    : type: Date, default: null
#   firstName     : String
#   lastName      : String
#   title         : String
#   phone         : String
#   preferences   : Object
#   rate_modifier : Number, default : 0
#   owner         : type: Boolean, default: false
#   removed       : type: Boolean, default: false
#   permissions   : type: [String], enum: constants.userPermissions, default: ['quote', 'book']
#   savedViews    :
#     shipmentList: [
#       name: type: String
#       queryString: type: String
#     ]

#   recent:
#     shipmentId             : type: mongoose.Schema.Types.ObjectId, ref: 'Shipment'
#     parcelShipmentId       : type: mongoose.Schema.Types.ObjectId, ref: 'Shipment'
#     spotQuoteGroupId       : {type: mongoose.Schema.Types.ObjectId},
#     spotQuoteGroups        : [{
#       groupId: type: mongoose.Schema.Types.ObjectId
#       selectedEquipmentTypes : Array
#       selectedUsers : Array
#       default: type: Boolean, default: false
#     }]
#   recover:
#     code    : type: String
#     date    : Date
#     expires : Date
#   direct:
#     code    : type: String
#     date    : Date
#     expires : Date
#   lastLogin : Date
#   crm:
#     id : String
#   shippedBolOnly : type: Boolean, default: false
#   stats:
#     spotQuotes:
#       quoteCount  : type: Number, default: 0
#       bookedCount : type: Number, default: 0
#       lastQuote   : Date
#       lastBooked  : Date
#     quotes:
#       quotedNmfc : type: Boolean, default: false
#       count      : type: Number, default: 0
#       last       : Date
#       api        : type: Number, default: 0
#       lastAPI    : Date
#     booked:
#       count : type: Number, default: 0
#       api   : type: Number, default: 0
#       last  : Date
#       lastAPI: Date
#     parcel:
#       quoteCount  : type: Number, default: 0
#       bookedCount : type: Number, default: 0
#       lastQuote   : Date
#       lastBooked  : Date
#   marketing:
#     subscribed: type: Boolean, default: true

# # output the virtual getters when calling toJSON
# AccountUserSchema.set 'toJSON', {getters : true}

# # Virtuals ---------------------------------------------------------------------

# AccountUserSchema.virtual('fullName').get ->
#   name = "#{@firstName or ''} #{@lastName or ''}".trim()
#   unless name.length then name = @username
#   name

# AccountUserSchema.virtual('email').get ->
#   @username

# # Methods ----------------------------------------------------------------------

# #sets this instance password and calls back with the resulting hashed password; does not save!
# AccountUserSchema.methods.setPassword = (password, cb) ->
#   hasher.hash password, (err, result) =>
#     if err then return cb err
#     @password = result
#     cb null, @password

# #compare passwords
# AccountUserSchema.methods.checkPassword = (password, done) ->
#   hasher.compare password, @password, done

# AccountUserSchema.methods.hasPermission = (permission) ->
#   return false if @removed
#   return true if @owner
#   return true if @permissions?.indexOf(permission) >= 0
#   return false

# AccountUserSchema.methods.toPublicObj = ->
#   tmp = @.toJSON()
#   _id            : tmp.id
#   username       : tmp.username
#   firstName      : tmp.firstName
#   lastName       : tmp.lastName
#   fullName       : tmp.fullName
#   title          : tmp.title
#   phone          : tmp.phone
#   preferences    : tmp.preferences or {}
#   created        : tmp.created
#   registered     : tmp.registered
#   lastLogin      : tmp.lastLogin
#   owner          : tmp.owner
#   shippedBolOnly : tmp.shippedBolOnly
#   permissions    : tmp.permissions
#   stats          : tmp.stats
#   recent         : tmp.recent
#   marketing      : tmp.marketing
#   rate_modifier  : tmp.rate_modifier
#   savedViews     : tmp.savedViews

# Exports ----------------------------------------------------------------------

# module.exports = mongoose.model 'AccountUser', AccountUserSchema
# module.exports.Schema = AccountUserSchema
