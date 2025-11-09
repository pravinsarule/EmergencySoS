const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const { requireRole } = require('../middleware/roles');
const { sendSOS, mySOS, pendingSOS, getAddress } = require('../controllers/sosController');

/**
 * POST /api/sos/send
 * Protected: user role
 * body: { serviceType, latitude, longitude }
 */
router.post('/send', auth, requireRole('user'), sendSOS);

/**
 * GET /api/sos/my
 * Protected: any authenticated user (shows only own SOS)
 */
router.get('/my', auth, mySOS);

/**
 * GET /api/sos/pending
 * Protected: receiver roles (police, ambulance, fire) - lists pending sos filtered by service type
 */
const { requireAnyRole } = require('../middleware/roles');
router.get('/pending', auth, requireAnyRole(['police', 'ambulance', 'fire']), pendingSOS);

/**
 * GET /api/sos/address
 * Public endpoint - get address from coordinates
 * query: { latitude, longitude }
 */
router.get('/address', getAddress);

module.exports = router;
