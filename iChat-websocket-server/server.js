const WebSocket = require("ws");
const http = require("http");

const PORT = process.env.PORT || 8080;

// Create an HTTP server (required for Railway)
const server = http.createServer();
const wss = new WebSocket.Server({ server });

let clients = {};  // Store connected clients

wss.on("connection", (ws) => {  
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

// Start the server
server.listen(PORT, () => {
    console.log(`WebSocket server running on ws://localhost:${PORT}`);
});


