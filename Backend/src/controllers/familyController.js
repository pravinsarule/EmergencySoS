const { pool } = require('../config/db');
const { notifyFamily } = require('../config/socket');

// Get all users who added this family member
async function getTrackedMembers(req, res) {
  try {
    const familyId = req.user.id; // Family member's ID
    
    // Find all users who added this family member
    const query = `
      SELECT DISTINCT
        u.id,
        u.name,
        u.email,
        u.phone,
        es.contact_name as family_name
      FROM emergency_settings es
      JOIN users u ON u.id = es.user_id
      WHERE es.service_type = 'family'
        AND (es.contact_number = $1 OR es.address = $2)
        AND u.role = 'user'
    `;
    
    const familyUser = await pool.query('SELECT phone, email FROM users WHERE id = $1', [familyId]);
    if (familyUser.rows.length === 0) {
      return res.status(404).json({ message: 'Family member not found' });
    }
    
    const { phone, email } = familyUser.rows[0];
    const result = await pool.query(query, [phone || '', email || '']);
    
    res.json({ members: result.rows });
  } catch (err) {
    console.error('getTrackedMembers error', err);
    res.status(500).json({ message: 'Server error' });
  }
}

// Get real-time location of a tracked member
async function getMemberLocation(req, res) {
  try {
    const familyId = req.user.id;
    const { userId } = req.params;
    
    // Verify this user has added this family member
    const verifyQuery = `
      SELECT es.* FROM emergency_settings es
      JOIN users f ON (f.phone = es.contact_number OR f.email = es.address)
      WHERE es.user_id = $1 AND f.id = $2 AND es.service_type = 'family'
    `;
    
    const verify = await pool.query(verifyQuery, [userId, familyId]);
    if (verify.rows.length === 0) {
      return res.status(403).json({ message: 'You are not authorized to track this user' });
    }
    
    // Get latest SOS location (as current location)
    const locationQuery = `
      SELECT latitude, longitude, address, created_at
      FROM sos_requests
      WHERE user_id = $1
      ORDER BY created_at DESC
      LIMIT 1
    `;
    
    const location = await pool.query(locationQuery, [userId]);
    
    if (location.rows.length === 0) {
      return res.json({ location: null, message: 'No location data available' });
    }
    
    res.json({ 
      location: {
        latitude: parseFloat(location.rows[0].latitude),
        longitude: parseFloat(location.rows[0].longitude),
        address: location.rows[0].address,
        updated_at: location.rows[0].created_at
      }
    });
  } catch (err) {
    console.error('getMemberLocation error', err);
    res.status(500).json({ message: 'Server error' });
  }
}

// Share location (called by user when they want to share location)
async function shareLocation(req, res) {
  try {
    const userId = req.user.id;
    const { latitude, longitude } = req.body;
    
    if (typeof latitude === 'undefined' || typeof longitude === 'undefined') {
      return res.status(400).json({ message: 'latitude and longitude required' });
    }
    
    // Get all family members who track this user
    const familyQuery = `
      SELECT DISTINCT f.id, f.email, f.phone
      FROM emergency_settings es
      JOIN users f ON (f.phone = es.contact_number OR f.email = es.address)
      WHERE es.user_id = $1 AND es.service_type = 'family' AND f.role = 'family'
    `;
    
    const families = await pool.query(familyQuery, [userId]);
    
    // Notify all family members via socket
    const locationData = {
      user_id: userId,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude),
      timestamp: new Date().toISOString()
    };
    
    families.rows.forEach(family => {
      notifyFamily(family.id, 'location:update', locationData);
    });
    
    res.json({ 
      message: 'Location shared successfully',
      shared_with: families.rows.length
    });
  } catch (err) {
    console.error('shareLocation error', err);
    res.status(500).json({ message: 'Server error' });
  }
}

module.exports = { getTrackedMembers, getMemberLocation, shareLocation };

