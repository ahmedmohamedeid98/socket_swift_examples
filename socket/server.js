
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

connections = [];

server.listen(process.env.PORT || 3000);

console.log("Server is listening...");

io.sockets.on("connection", function(socket) {
	connections.push(socket);
	console.log("%s sockets are connected", connections.length);

	//Disconnected
	socket.on("disconnect", function(data) {
		connections.splice(connections.indexOf(socket), 1);
	});

	socket.on("NodeJs Server Port", (data) => {
		console.log(data)
		io.sockets.emit("IOS Client Port", {msg: "Hello IOS From Server"})
	});

});


