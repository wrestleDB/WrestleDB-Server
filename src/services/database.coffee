mongoose = require('mongoose')
# colors = require('colors') * need to figure out a way to handle keeping this a dev-dependency by dev vs production console logging

handleFailure = () =>
  console.log("There was an error")#.bold.red.bgWhite)
  return process.exit(1)

module.exports =
  connect: () =>
    connection = mongoose.connection

    mongoose.connection.on "error", handleFailure

    mongoose.connection.on "open", () =>
      console.log("MongoDB connected to[-- #{connection.db.databaseName} --]")#.grey.bgRed)

    mongoose.connect(process.env.MONGO_CLIENT_WRESTLEDB, { useNewUrlParser : true } )
  #TO DO: Add disconnect for future CLI tasks