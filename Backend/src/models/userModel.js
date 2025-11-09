const { pool } = require('../config/db');

async function createUser({ name, email, password_hash, role = 'user', phone = null }) {
  const q = `INSERT INTO users (name, email, password_hash, role, phone) VALUES ($1,$2,$3,$4,$5) RETURNING id, name, email, role, phone, created_at`;
  const values = [name, email, password_hash, role, phone];
  const r = await pool.query(q, values);
  return r.rows[0];
}

async function findByEmail(email) {
  const r = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
  return r.rows[0];
}

async function findById(id) {
  const r = await pool.query('SELECT id, name, email, role, phone, created_at FROM users WHERE id = $1', [id]);
  return r.rows[0];
}

module.exports = { createUser, findByEmail, findById };
