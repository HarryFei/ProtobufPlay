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


proto_configs = require './protocol/protocol'


setup_router = (proto) ->
  get_class = (root, class_name) ->
     eval "root.#{class_name}"

  sent= get_class(protocol, proto.messageSentName)
  receive= get_class(protocol, proto.messageReceivedName)

  app.post proto.url, (req, res) ->
    sent.decode(req.rawBody)
    ret = new receive()
    res.send(ret.encodeNB())

for p in proto_configs
  setup_router(p)

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
