const WebSocket = require("ws");

const server = new WebSocket.Server({ port: 8080 });
let clients = {};

server.on("connection", (ws) => {
    console.log("New client connected!");

    ws.on("message", (message) => {
        console.log("Received:", message);
        const data = JSON.parse(message);

        if (data.type === "register") {
            clients[data.username] = ws;
            console.log(`User registered: ${data.username}`);
        } else if (data.type === "message") {
            const recipientSocket = clients[data.to];
            if (recipientSocket) {
                recipientSocket.send(JSON.stringify(data)); // Send message to recipient
            }
        }
    });

    ws.on("close", () => {
        console.log("Client disconnected!");
    });
});

console.log("WebSocket server running on ws://localhost:8080");
