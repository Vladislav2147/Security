'use strict';

var path = require('path');
var https = require('https');
var fs = require('fs');


var oas3Tools = require('oas3-tools');
var serverPort = 1337;

// swaggerRouter configuration
var options = {
    routing: {
        controllers: path.join(__dirname, './controllers')
    },
};

var expressAppConfig = oas3Tools.expressAppConfig(path.join(__dirname, 'api/openapi.yaml'), options);
var app = expressAppConfig.getApp();

// Initialize the Swagger middleware
https.createServer({
    key: fs.readFileSync('./hash.my-services.com.key'),
    cert: fs.readFileSync('./hash.my-services.com.crt'),
    passphrase: '1234'
}, app).listen(serverPort, function () {
    console.log('Your server is listening on port %d (https://localhost:%d)', serverPort, serverPort);
    console.log('Swagger-ui is available on https://localhost:%d/docs', serverPort);
});

