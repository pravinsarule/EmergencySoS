const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const { requireRole } = require('../middleware/roles');
const { getTrackedMembers, getMemberLocation, shareLocation } = require('../controllers/familyController');

/**
 * GET /api/family/members
 * Protected: family role - get all users who added this family member
 */
router.get('/members', auth, requireRole('family'), getTrackedMembers);

/**
 * GET /api/family/location/:userId
 * Protected: family role - get real-time location of a tracked member
 */
router.get('/location/:userId', auth, requireRole('family'), getMemberLocation);

/**
 * POST /api/family/share-location
 * Protected: user role - share current location with family members
 */
router.post('/share-location', auth, requireRole('user'), shareLocation);

module.exports = router;

