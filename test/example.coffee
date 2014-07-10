request = require("request")
should = require("should")

  
path = require "path"
ProtoBuf = require("protobufjs")
builder = ProtoBuf.loadProtoFile(path.join(__dirname, "../protocol", "example.proto"))
protocol = builder.build()

describe "TEST_CONNECT", ->
  data =  new protocol.com.trantect.Connect()
  data.num = 1
  it "TEST_POST_XML", (done) ->
    options =
      url: "http://127.0.0.1:5000/example"
      headers:
        "content-type": "application/octet-stream"
      body: data.encodeNB()

      encoding: null

    request.post options, (error, response, body) ->

      should.not.exist error
      
      buffer = protocol.com.trantect.Ack.decode(body)
      should(buffer.payload.toBuffer()).eql(new Buffer("hello"))

      done()
      return

    return

  return
