const { pool } = require('../config/db');

async function createSOS({ user_id, service_type, latitude, longitude, address }) {
  const q = `INSERT INTO sos_requests (user_id, service_type, latitude, longitude, address) VALUES ($1,$2,$3,$4,$5) RETURNING *`;
  const values = [user_id, service_type, latitude, longitude, address];
  const r = await pool.query(q, values);
  return r.rows[0];
}

async function getLatestSOSForUser(user_id, limit = 10) {
  const r = await pool.query('SELECT * FROM sos_requests WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2', [user_id, limit]);
  return r.rows;
}

async function getPendingSOS(serviceType = null) {
  let query = "SELECT s.*, u.name as user_name, u.phone as user_phone FROM sos_requests s JOIN users u ON u.id = s.user_id WHERE s.status = 'pending'";
  const params = [];
  
  if (serviceType) {
    query += " AND s.service_type = $1";
    params.push(serviceType);
  }
  
  query += " ORDER BY s.created_at DESC";
  
  const r = await pool.query(query, params);
  return r.rows;
}

module.exports = { createSOS, getLatestSOSForUser, getPendingSOS };
