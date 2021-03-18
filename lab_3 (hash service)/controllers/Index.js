'use strict';

var utils = require('../utils/writer.js');
var Index = require('../service/IndexService');

module.exports.rootGET = function rootGET (req, res, next) {
  Index.rootGET()
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
