var express = require('express');
var router = express.Router();

const users = [
  {name : "John", lastName : "Doe", userName : "jdoe"},
  {name : "Harry", lastName : "Kane", userName : "hkane"},
  {name : "Mohamed", lastName : "Salah", userName : "msalah"}
]

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send(users);
});

module.exports = router;
