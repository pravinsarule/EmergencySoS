const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { createUser, findByEmail } = require('../models/userModel');
require('dotenv').config();
const { pool } = require('../config/db'); // <-- add this


const SALT_ROUNDS = 10;

function signToken(user) {
  return jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN || '7d' });
}

async function register(req, res) {
  try {
    const { name, email, password, role = 'user', phone } = req.body;
    if (!name || !email || !password) return res.status(400).json({ message: 'name, email, password required' });

    const existing = await findByEmail(email.toLowerCase());
    if (existing) return res.status(400).json({ message: 'Email already in use' });

    const password_hash = await bcrypt.hash(password, SALT_ROUNDS);
    const user = await createUser({ name, email: email.toLowerCase(), password_hash, role, phone });

    const token = signToken(user);
    res.status(201).json({ user, token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: 'email & password required' });

    const user = await findByEmail(email.toLowerCase());
    if (!user) return res.status(401).json({ message: 'Invalid credentials' });

    const ok = await bcrypt.compare(password, user.password_hash);
    if (!ok) return res.status(401).json({ message: 'Invalid credentials' });

    const token = signToken(user);
    // omit password_hash in response
    const { password_hash, ...safeUser } = user;
    res.json({ user: safeUser, token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}



async function upsertFamilyContact (req, res){
    try {
        const userId = req.user.id; // from authenticateUser middleware
        const { family_email, family_phone, family_name } = req.body;

        if (!family_email && !family_phone) {
            return res.status(400).json({ message: 'Family email or phone is required' });
        }

        // Find family member by email or phone
        let familyMember = null;
        if (family_email) {
            const result = await pool.query('SELECT id, name, email, phone, role FROM users WHERE email = $1 AND role = $2', [family_email.toLowerCase(), 'family']);
            familyMember = result.rows[0];
        } else if (family_phone) {
            const result = await pool.query('SELECT id, name, email, phone, role FROM users WHERE phone = $1 AND role = $2', [family_phone, 'family']);
            familyMember = result.rows[0];
        }

        if (!familyMember) {
            return res.status(404).json({ message: 'Family member not found. Please ensure they are registered with family role.' });
        }

        // Store family relationship
        const query = `
            INSERT INTO emergency_settings(user_id, service_type, contact_name, contact_number, address)
            VALUES ($1, 'family', $2, $3, $4)
            ON CONFLICT(user_id, service_type)
            DO UPDATE SET 
                contact_name = EXCLUDED.contact_name,
                contact_number = EXCLUDED.contact_number,
                address = EXCLUDED.address
            RETURNING *;
        `;

        const { rows } = await pool.query(query, [
            userId, 
            family_name || familyMember.name, 
            familyMember.phone || family_phone, 
            familyMember.email
        ]);

        res.status(200).json({ 
            message: 'Family contact saved successfully', 
            data: rows[0],
            family_member: familyMember
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

module.exports = { register, login, upsertFamilyContact };
