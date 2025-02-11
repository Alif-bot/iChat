const WebSocket = require("ws");

const server = new WebSocket.Server({ port: 8080 });
let clients = {};  // Store connected clients

server.on("connection", (ws) => {  
    console.log("New client connected!");

    ws.on("message", (message) => {
        console.log("Received:", message);
        
        try {
            const data = JSON.parse(message);

            if (data.type === "register") {
                clients[data.username] = ws; // Store user connection
                console.log(`User registered: ${data.username}`);
            } else if (data.type === "message") {
                const recipientSocket = clients[data.to];
                if (recipientSocket) {
                    recipientSocket.send(JSON.stringify(data)); // Send message to recipient
                } else {
                    console.log(`Recipient ${data.to} not found.`);
                }
            }
        } catch (error) {
            console.error("Error parsing JSON:", error);
        }
    });

    ws.on("close", () => {
        console.log("Client disconnected!");
        Object.keys(clients).forEach((username) => {
            if (clients[username] === ws) {
                delete clients[username]; // Remove disconnected user
            }
        });
    });
});

console.log("WebSocket server running on ws://localhost:8080");

