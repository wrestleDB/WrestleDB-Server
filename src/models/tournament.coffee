mongoose       = require 'mongoose'

bracketTypes = ['double-elimination', 'round-robin', 'dual', 'dual-round-robin', 'Double Elimination', 'Round Robin']

TournamentSchema = new mongoose.Schema
  status    : type: String, default: 'created' #, enums: ['created', 'inProgress', 'complete', 'cancelled']
  # hostUser  : type: mongoose.Schema.Types.ObjectId, required:true # the owning user
  created   : type: Date, default: Date.now
  eventName : type: String, required: true
  bracketType : type: String, enum: bracketTypes, default: 'double-elimination'
  eventDate :
    startDate : type: Date
    endDate   : type: Date
  location : # Send me location
     address  : String
     address2 : String
     city     : String
     state    : String
     postalCode: String
     country  : type: String, default: "US"
     lat      : Number
     lng      : Number
     timezone : String
  registration :
    numberOfMats   : type: Number, required: true
    entryFee       : type: Number, required: true
    # inviteOnly     : type: Boolean, default: false #TODO: undo strict type matching
    openDate       : type: Date, default: Date.now
    # closeDate      : type: Date, required: true
    minWrestlers   : type: Number, default: 2
    maxWrestlers   : type: Number, default: 2
    earlyDiscount  : Number # Discount for signing up early
    earlyOpenDate  : Date # Open date for early discount to apply
    earlyCloseDate : Date # Close date for early discount to apply


TournamentSchema.set 'toJSON', {getters : true} # output the virtual getters when calling toJSON

# Virtuals ---------------------------------------------------------------------

TournamentSchema.virtual('formattedEventName').get ->
  if @registration.inviteOnly
    return "The #{@eventName} Invitational"
  else
    return "The #{@eventName} Open"

# Methods ----------------------------------------------------------------------
TournamentSchema.methods.checkForEarlyDiscount = (registrationDate, done) ->
  return false # TODO: Fix this

module.exports = mongoose.model 'tournaments', TournamentSchema
module.exports.Schema = TournamentSchema