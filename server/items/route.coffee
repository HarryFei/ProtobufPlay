express = require("express")
router = express.Router()

items = require("./items")

router.get "/all", items.all
router.post "/", items.create
router.put "/:id", items.update
router.delete "/:id", items.remove


module.exports = router
