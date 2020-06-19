cors = require "cors"

module.exports = ->
  # General Express configuration
  app.use express.json()
  app.set 'port', process.env.PORT or 8081
  app.use cors()

  # Setup Database connection
  # app.set 'db-uri', process.env.MONGO_CLIENT_WRESTLEDB
  # switch app.get('env')
  #   when 'development' then app.set 'db-uri', process.env.MONGO_CLIENT_WRESTLEDB
  #   when 'staging'     then app.set 'db-uri', process.env.MONGO_CLIENT_WRESTLEDB
  #   when 'production'  then app.set 'db-uri', process.env.MONGO_CLIENT_WRESTLEDB

