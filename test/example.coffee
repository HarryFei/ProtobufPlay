request = require("request")
should = require("should")

  
path = require "path"
ProtoBuf = require("protobufjs")
builder = ProtoBuf.loadProtoFile(path.join(__dirname, "../protocol", "example.proto"))
protocol = builder.build()

APP_URL_ROOT = "http://127.0.0.1:5000"

proto_configs = require '../protocol/protocol'

describe "Api2", ->
  setup_test = (proto) ->

    get_class = (root, class_name) ->
      eval "root.#{class_name}"

    sent= get_class(protocol, proto.messageSentName)
    receive= get_class(protocol, proto.messageReceivedName)

    it "##{proto.url}", (done) ->
      url = "#{APP_URL_ROOT}#{proto.url}"
      options =
        url: url
        headers:
          "content-type": "application/octet-stream"
        body: (new sent()).encodeNB()
        encoding: null

      request.post options, (error, response, body) ->
    
        should.not.exist error
        buffer = receive.decode(body)
        should(buffer).not.equal(null)
        should(buffer).eql(new receive())

        done()
    
  for p in proto_configs
    setup_test(p)


