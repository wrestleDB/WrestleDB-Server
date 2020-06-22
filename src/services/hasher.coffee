bcrypt = require 'bcrypt'

exports.hash = (word, callback) ->
  bcrypt.genSalt 10, (err,salt) ->
    bcrypt.hash word, salt, (err,hash) ->
      callback err,hash

exports.compare = (word,hash, callback) ->
  bcrypt.compare word, hash, (err,result) ->
    callback(err,result)
