# ### Module dependencies.
express = require("express")
path = require("path")
favicon = require("serve-favicon")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
xmldomparser = require('express-xml-domparser')

app = express()

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use favicon(__dirname + '/public/favicon.ico')

if process.env.MODE_ENV != "test"
    app.use logger("dev")


app.use (req, res, next) ->
  data = new Buffer('')
  req.on "data", (chunk) ->
    data = Buffer.concat [data,chunk]

  req.on "end", ->
    req.rawBody = data
    next()

#   data = new Buffer('')
#   req.on "data", (chunk) ->
#     data = Buffer.concat [data,chunk]

#     # req.removeListener("end")
#   req.once "end", ->
#     req.test = data
#   next()

app.use bodyParser.json()
app.use xmldomparser()
app.use cookieParser()


app.use express.static(path.join(__dirname, "build"))

#/ error handlers
# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return


# index
app.get '/', (req, res) ->
  res.render "index"

ProtoBuf = require("protobufjs")
builder = ProtoBuf.loadProtoFile(path.join(__dirname, "protocol", "example.proto"))
protocol = builder.build()


  
app.post '/example', (req, res) ->

  protocol.com.trantect.Connect.decode(req.rawBody)

  ret = new protocol.com.trantect.Ack()
  ret.num = 1
  ret.payload = "hello";
  buffer = ret.encodeNB()
  res.send(buffer)

# items
items = require("./server/items/route")
app.use('/item', items)

# xmldom
xmlparse= require("./server/xmlparse")
app.use('/xmlparse', xmlparse)



# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return

module.exports = app
