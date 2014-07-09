var express = require('express');
var router = express.Router();
var parser = require('xml2json');

/* GET users listing. */
router.post('/', function(req, res) {
  var xmldom = req.xmlDom;
  // send back json data
  var jsonContent = parser.toJson("" + xmldom);
  res.send(jsonContent);
});

module.exports = router;
