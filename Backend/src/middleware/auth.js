const jwt = require('jsonwebtoken');
const { pool } = require('../config/db');
require('dotenv').config();

const authMiddleware = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).json({ message: 'Missing authorization header' });

  const token = authHeader.split(' ')[1];
  if (!token) return res.status(401).json({ message: 'Invalid authorization format' });

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    // fetch user minimal info
    const result = await pool.query('SELECT id, name, email, role FROM users WHERE id = $1', [payload.id]);
    if (result.rows.length === 0) return res.status(401).json({ message: 'User not found' });

    req.user = result.rows[0];
    next();
  } catch (err) {
    console.error(err);
    return res.status(401).json({ message: 'Invalid/expired token' });
  }
};

module.exports = authMiddleware;
