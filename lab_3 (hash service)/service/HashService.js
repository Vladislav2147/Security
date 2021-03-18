'use strict';

const crypto = require('crypto');

/**
 * Returns hash
 *
 * returns inline_response_200
 **/
exports.hashPOST = function(req) {
    return new Promise(function (resolve, reject) {

        var data = req.body.data;
        var hash = getHash(data);

        var response = {};
        response['application/json'] = {
            "hash": hash
        };
        if (Object.keys(response).length > 0) {
            resolve(response[Object.keys(response)[0]]);
        } else {
            resolve();
        }
    
  });
}

/**
 * Checkes integrity of data
 *
 * body Body_1 Data string for hashing
 * returns inline_response_200_1
 **/
exports.vhashPOST = function (body) {
    return new Promise(function (resolve, reject) {

        var data = Buffer.from(body.data, 'base64');
        var hash = getHash(data);

        var state = 1;
        if (hash == body.hash) {
            state = 0;
        }

        var examples = {};
        examples['application/json'] = {
            "status": state
        };
        if (Object.keys(examples).length > 0) {
            resolve(examples[Object.keys(examples)[0]]);
        } else {
            resolve();
        }
    });
}

function getHash(data) {
    return crypto
        .createHash("sha256")
        .update(data, "utf-8")
        .digest("hex")

    //return hash
    //    .split("")
    //    .map(function (ch) {
    //        return ch.charCodeAt(0).toString(16)
    //    })
    //    .join("")
}