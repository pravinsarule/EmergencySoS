require('dotenv').config();
const express = require('express');
const http = require('http');
const cors = require('cors');
const helmet = require('helmet');

const { initSocket } = require('./src/config/socket');
const authRoutes = require('./src/routes/authRoutes');
const sosRoutes = require('./src/routes/sosRoutes');
const familyRoutes = require('./src/routes/familyRoutes');
const { pool } = require('./src/config/db');

const app = express();
const server = http.createServer(app);

initSocket(server); // initialize socket.io

app.use(helmet());
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: false
}));
app.use(express.json());

// routes
app.use('/api/auth', authRoutes);
app.use('/api/sos', sosRoutes);
app.use('/api/family', familyRoutes);

// health
app.get('/health', (req, res) => res.json({ ok: true, time: new Date() }));

const PORT = process.env.PORT || 4000;

server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
