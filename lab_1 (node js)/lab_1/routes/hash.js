'use strict';
const express = require('express');
const path = require('path');
const crypto = require('crypto');
var router = express.Router();

router.get('/', function (req, res) {
    res.sendFile(path.join(__dirname, '../public/html', 'hash.html'))
});

router.post('/', function (req, res) {

    var data = Buffer.from(req.body.data, "base64").toString();
    var hash = crypto
        .createHash("sha256")
        .update(data, "utf-8")
        .digest("hex")
  
    var responseHash = new Object()
    responseHash.hash = Buffer.from(hash).toString('base64')
    res.send(JSON.stringify(responseHash));
});

module.exports = router;
