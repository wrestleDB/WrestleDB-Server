mongoose = require('mongoose')

Schema = mongoose.Schema

wrestlerSchema = new Schema
  usawId           : String,
  email            : {type: String, default: ""},
  name           : {type: String, required: true},
  createdAt      : Date,
  # firstName        : {type: String, required: true},
  # lastName         : {type: String, required: true},
  dob              : Date,
  phone            : String,
  gender           : String,
  address1         : String,
  address2         : String,
  city             : String,
  state            : String,
  zip              : String,
  guardians        : [String]

Wrestler = mongoose.model('Wrestler', wrestlerSchema)

module.exports = Wrestler
