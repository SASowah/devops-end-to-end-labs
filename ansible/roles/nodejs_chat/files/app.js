const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const path = require('path');
const client = require('prom-client');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// Prometheus metrics setup
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();

// Custom metric example: Chat message counter
const chatCounter = new client.Counter({
  name: 'chat_messages_total',
  help: 'Total number of chat messages sent',
});

// Serve static files
app.use(express.static(__dirname));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Expose /metrics endpoint
app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
  } catch (ex) {
    res.status(500).end(ex);
  }
});

// Socket.IO logic
io.on('connection', socket => {
  console.log('User connected');

  socket.on('chat message', (msg) => {
    console.log('Message received:', msg);
    chatCounter.inc(); // Increment custom metric
    io.emit('chat message', msg);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

server.listen(3000, () => console.log('Chat app running on port 3000'));
