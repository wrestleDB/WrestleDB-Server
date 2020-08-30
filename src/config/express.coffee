cors = require "cors"
helmet = require "helmet"

module.exports = ->
  # General Express configuration
  console.log "EXPRESS - Setting up configuration"
  app.set 'port', process.env.PORT or 8081
  app.use helmet()
  app.use express.json()
  app.use cors()

  # Setup Database connection
  # app.set 'db-uri', process.env.MONGO_CLIENT_WRESTLEDB
  # switch app.get('env')
  #   when 'development' then app.set 'db-uri', process.env.MONGO_CLIENT_WRESTLEDB
  #   when 'staging'     then app.set 'db-uri', process.env.MONGO_CLIENT_WRESTLEDB
  #   when 'production'  then app.set 'db-uri', process.env.MONGO_CLIENT_WRESTLEDB

