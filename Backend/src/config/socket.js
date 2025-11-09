const { Server } = require('socket.io');

let io;
const familySockets = new Map(); // Map of family_id -> socket_id

function initSocket(server) {
  io = new Server(server, {
    cors: { origin: '*', methods: ['GET', 'POST'] }
  });

  io.on('connection', (socket) => {
    console.log('Socket connected:', socket.id);

    // receivers join 'receivers' room (they should do this on client after auth)
    socket.on('join:receivers', (data) => {
      socket.join('receivers');
      console.log(`Socket ${socket.id} joined receivers`);
    });

    // Family members join their own room for tracking
    socket.on('join:family', (data) => {
      const { familyId } = data;
      if (familyId) {
        socket.join(`family:${familyId}`);
        familySockets.set(familyId, socket.id);
        console.log(`Socket ${socket.id} joined family room: ${familyId}`);
      }
    });

    socket.on('disconnect', () => {
      // Remove from family sockets map
      for (const [familyId, socketId] of familySockets.entries()) {
        if (socketId === socket.id) {
          familySockets.delete(familyId);
          break;
        }
      }
      console.log('Socket disconnected:', socket.id);
    });
  });
}

function notifyReceivers(event, payload) {
  if (!io) return;
  io.to('receivers').emit(event, payload);
}

function notifyFamily(familyId, event, payload) {
  if (!io) return;
  io.to(`family:${familyId}`).emit(event, payload);
}

module.exports = { initSocket, notifyReceivers, notifyFamily };
