'use strict'

function send() {
    var data = document.getElementById("data").value
    var requestMessage = new Object()
    requestMessage.data = btoa(data)
    let xhr = new XMLHttpRequest();
    xhr.open("POST", "http://localhost:1337/hash")
    xhr.setRequestHeader("Content-type", "application/json");
    xhr.send(JSON.stringify(requestMessage))
    xhr.onload = function () {
        if (xhr.status == 200) {
            var responseHash = JSON.parse(xhr.responseText);
            document.getElementById("hash").value = atob(responseHash.hash)
        }
    }
}