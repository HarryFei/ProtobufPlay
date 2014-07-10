fs = require("fs")
file = __dirname + "/protocol.json"
JSON.minify = JSON.minify || require("node-json-minify")

module.exports = JSON.parse(JSON.minify(fs.readFileSync(file, 'utf8')));
