const express = require('express');
const router = express.Router();
const { register, login , upsertFamilyContact} = require('../controllers/authController');

const auth = require('../middleware/auth');
const { requireRole } = require('../middleware/roles');

/**
 * POST /api/auth/register
 * body: { name, email, password, role } role optional (user|receiver)
 */
router.post('/register', register);

/**
 * POST /api/auth/login
 * body: { email, password }
 */
router.post('/login', login);

router.post('/family',  auth, requireRole('user'), upsertFamilyContact);

module.exports = router;
