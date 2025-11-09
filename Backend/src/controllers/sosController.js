// const { reverseGeocode } = require('../utils/geoapify');
// const { createSOS, getLatestSOSForUser, getPendingSOS } = require('../models/sosModel');
// const { notifyReceivers, notifyFamily } = require('../config/socket');
// const { pool } = require('../config/db');

// async function sendSOS(req, res) {
//   try {
//     const { serviceType, latitude, longitude } = req.body;
//     const userId = req.user.id;

//     if (!serviceType || typeof latitude === 'undefined' || typeof longitude === 'undefined') {
//       return res.status(400).json({ message: 'serviceType, latitude, longitude required' });
//     }

//     // get address via Geoapify (best effort)
//     const address = await reverseGeocode(latitude, longitude);

//     // create in DB
//     const sos = await createSOS({
//       user_id: userId,
//       service_type: serviceType,
//       latitude: parseFloat(latitude),
//       longitude: parseFloat(longitude),
//       address
//     });

//     // Ensure numeric values are properly formatted
//     const formattedSOS = {
//       ...sos,
//       latitude: parseFloat(sos.latitude),
//       longitude: parseFloat(sos.longitude),
//       id: parseInt(sos.id),
//       user_id: parseInt(sos.user_id)
//     };

//     // notify all connected receivers via socket.io
//     notifyReceivers('sos:new', {
//       sos_id: formattedSOS.id,
//       user_id: formattedSOS.user_id,
//       service_type: formattedSOS.service_type,
//       latitude: formattedSOS.latitude,
//       longitude: formattedSOS.longitude,
//       address: formattedSOS.address,
//       created_at: formattedSOS.created_at
//     });

//     // Notify family members about the SOS
//     try {
//       const familyQuery = `
//         SELECT DISTINCT f.id
//         FROM emergency_settings es
//         JOIN users f ON (f.phone = es.contact_number OR f.email = es.address)
//         WHERE es.user_id = $1 AND es.service_type = 'family' AND f.role = 'family'
//       `;
//       const families = await pool.query(familyQuery, [userId]);

//       families.rows.forEach(family => {
//         notifyFamily(family.id, 'sos:new', {
//           sos_id: formattedSOS.id,
//           user_id: formattedSOS.user_id,
//           service_type: formattedSOS.service_type,
//           latitude: formattedSOS.latitude,
//           longitude: formattedSOS.longitude,
//           address: formattedSOS.address,
//           created_at: formattedSOS.created_at
//         });
//       });
//     } catch (err) {
//       console.error('Error notifying family:', err);
//     }

//     return res.status(201).json({ sos: formattedSOS });
//   } catch (err) {
//     console.error('sendSOS error', err);
//     return res.status(500).json({ message: 'Server error' });
//   }
// }

// async function mySOS(req, res) {
//   try {
//     const userId = req.user.id;
//     const list = await getLatestSOSForUser(userId, 20);
    
//     // Format numeric values properly
//     const formattedList = list.map(sos => ({
//       ...sos,
//       latitude: parseFloat(sos.latitude),
//       longitude: parseFloat(sos.longitude),
//       id: parseInt(sos.id),
//       user_id: parseInt(sos.user_id)
//     }));
    
//     res.json({ list: formattedList });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ message: 'Server error' });
//   }
// }

// async function pendingSOS(req, res) {
//   try {
//     const receiverRole = req.user.role;
    
//     // Map receiver roles to service types
//     const roleToServiceType = {
//       'police': 'police',
//       'ambulance': 'ambulance',
//       'fire': 'fire'
//     };
    
//     const serviceType = roleToServiceType[receiverRole] || null;
    
//     // Get SOS filtered by service type for this receiver
//     const list = await getPendingSOS(serviceType);
    
//     // Format numeric values properly
//     const formattedList = list.map(sos => ({
//       ...sos,
//       latitude: parseFloat(sos.latitude),
//       longitude: parseFloat(sos.longitude),
//       id: parseInt(sos.id),
//       user_id: parseInt(sos.user_id)
//     }));
    
//     res.json({ list: formattedList });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ message: 'Server error' });
//   }
// }

// async function getAddress(req, res) {
//   try {
//     const { latitude, longitude } = req.query;
    
//     if (typeof latitude === 'undefined' || typeof longitude === 'undefined') {
//       return res.status(400).json({ message: 'latitude and longitude required' });
//     }

//     const lat = parseFloat(latitude);
//     const lon = parseFloat(longitude);

//     if (isNaN(lat) || isNaN(lon)) {
//       return res.status(400).json({ message: 'Invalid latitude or longitude' });
//     }

//     const address = await reverseGeocode(lat, lon);
    
//     if (address) {
//       return res.json({ address });
//     } else {
//       return res.json({ address: null, message: 'Address not found' });
//     }
//   } catch (err) {
//     console.error('getAddress error', err);
//     return res.status(500).json({ message: 'Server error' });
//   }
// }

// module.exports = { sendSOS, mySOS, pendingSOS, getAddress };
const { reverseGeocode } = require('../utils/geoapify');
const { createSOS, getLatestSOSForUser, getPendingSOS } = require('../models/sosModel');
const { notifyReceivers, notifyFamily } = require('../config/socket');
const { pool } = require('../config/db');

async function sendSOS(req, res) {
  try {
    const { serviceType, latitude, longitude } = req.body;
    const userId = req.user.id;

    if (!serviceType || typeof latitude === 'undefined' || typeof longitude === 'undefined') {
      return res.status(400).json({ message: 'serviceType, latitude, longitude required' });
    }

    // get address via Geoapify (best effort)
    const address = await reverseGeocode(latitude, longitude);

    // create in DB
    const sos = await createSOS({
      user_id: userId,
      service_type: serviceType,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude),
      address
    });

    // Ensure numeric values are properly formatted
    const formattedSOS = {
      ...sos,
      latitude: parseFloat(sos.latitude),
      longitude: parseFloat(sos.longitude),
      id: parseInt(sos.id),
      user_id: parseInt(sos.user_id)
    };

    // notify all connected receivers via socket.io
    notifyReceivers('sos:new', {
      sos_id: formattedSOS.id,
      user_id: formattedSOS.user_id,
      service_type: formattedSOS.service_type,
      latitude: formattedSOS.latitude,
      longitude: formattedSOS.longitude,
      address: formattedSOS.address,
      created_at: formattedSOS.created_at
    });

    // Notify ONLY the family members that THIS USER has added to their contacts
    try {
      const familyQuery = `
        SELECT DISTINCT f.id, f.name, f.email
        FROM emergency_settings es
        JOIN users f ON (
          (es.contact_number IS NOT NULL AND f.phone = es.contact_number) OR
          (es.address IS NOT NULL AND f.email = es.address)
        )
        WHERE es.user_id = $1 
          AND es.service_type = 'family' 
          AND f.role = 'family'
          AND f.id IS NOT NULL
      `;
      const families = await pool.query(familyQuery, [userId]);

      if (families.rows.length > 0) {
        console.log(`Notifying ${families.rows.length} family member(s) for user ${userId}`);
        
        families.rows.forEach(family => {
          notifyFamily(family.id, 'sos:new', {
            sos_id: formattedSOS.id,
            user_id: formattedSOS.user_id,
            user_name: req.user.name || 'Unknown',
            service_type: formattedSOS.service_type,
            latitude: formattedSOS.latitude,
            longitude: formattedSOS.longitude,
            address: formattedSOS.address,
            created_at: formattedSOS.created_at
          });
        });
      } else {
        console.log(`No family members found for user ${userId}`);
      }
    } catch (err) {
      console.error('Error notifying family:', err);
      // Don't fail the SOS creation if family notification fails
    }

    return res.status(201).json({ sos: formattedSOS });
  } catch (err) {
    console.error('sendSOS error', err);
    return res.status(500).json({ message: 'Server error' });
  }
}

async function mySOS(req, res) {
  try {
    const userId = req.user.id;
    const list = await getLatestSOSForUser(userId, 20);
    
    // Format numeric values properly
    const formattedList = list.map(sos => ({
      ...sos,
      latitude: parseFloat(sos.latitude),
      longitude: parseFloat(sos.longitude),
      id: parseInt(sos.id),
      user_id: parseInt(sos.user_id)
    }));
    
    res.json({ list: formattedList });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

async function pendingSOS(req, res) {
  try {
    const receiverRole = req.user.role;
    
    // Map receiver roles to service types
    const roleToServiceType = {
      'police': 'police',
      'ambulance': 'ambulance',
      'fire': 'fire'
    };
    
    const serviceType = roleToServiceType[receiverRole] || null;
    
    // Get SOS filtered by service type for this receiver
    const list = await getPendingSOS(serviceType);
    
    // Format numeric values properly
    const formattedList = list.map(sos => ({
      ...sos,
      latitude: parseFloat(sos.latitude),
      longitude: parseFloat(sos.longitude),
      id: parseInt(sos.id),
      user_id: parseInt(sos.user_id)
    }));
    
    res.json({ list: formattedList });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

async function getAddress(req, res) {
  try {
    const { latitude, longitude } = req.query;
    
    if (typeof latitude === 'undefined' || typeof longitude === 'undefined') {
      return res.status(400).json({ message: 'latitude and longitude required' });
    }

    const lat = parseFloat(latitude);
    const lon = parseFloat(longitude);

    if (isNaN(lat) || isNaN(lon)) {
      return res.status(400).json({ message: 'Invalid latitude or longitude' });
    }

    const address = await reverseGeocode(lat, lon);
    
    if (address) {
      return res.json({ address });
    } else {
      return res.json({ address: null, message: 'Address not found' });
    }
  } catch (err) {
    console.error('getAddress error', err);
    return res.status(500).json({ message: 'Server error' });
  }
}

module.exports = { sendSOS, mySOS, pendingSOS, getAddress };