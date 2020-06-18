console.log "\nStarting App\n"
cors    = require "cors"
express = require "express"
db      = require './services/database'

app = express()

# Connect to DB
db.connect()

app.use express.json()
app.use cors()

port = process.env.PORT or 8081
app.listen(port, () => console.log "Express App listening on port #{port}!")