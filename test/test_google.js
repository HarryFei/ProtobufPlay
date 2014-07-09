var request = require('request');
var should = require('should');

require('coffee-script/register');
var app = require('../app.coffee');

describe('TEST_CONNECT', function() {

    it('TEST_POST_XML', function(done) {
	    var options = {
		    url: 'http://127.0.0.1:5000/xmlparse',
		    headers: {'content-type': 'application/xml'},  
		    body: "<note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>",	
	    };	
	    request.post(options, function(error, response, body) {
		    should.not.exist(error);
		    var jsonObject = JSON.parse(body);
		    should(jsonObject).have.property("note", {"to":"Tove","from":"Jani","heading":"Reminder","body":"Don&apos;t forget me this weekend!"});
		    done();
	    });
    });

});
