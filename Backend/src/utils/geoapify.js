const axios = require('axios');
require('dotenv').config();

const GEOAPIFY_KEY = process.env.GEOAPIFY_KEY;

async function reverseGeocode(latitude, longitude) {
  if (!GEOAPIFY_KEY) {
    console.warn('GEOAPIFY_KEY not set — returning empty address');
    return null;
  }
  try {
    const url = `https://api.geoapify.com/v1/geocode/reverse?lat=${encodeURIComponent(latitude)}&lon=${encodeURIComponent(longitude)}&apiKey=${GEOAPIFY_KEY}`;
    const resp = await axios.get(url, { timeout: 8000 });
    if (resp.data && resp.data.features && resp.data.features.length > 0) {
      const props = resp.data.features[0].properties;
      
      // Use the formatted address if available (most reliable)
      if (props.formatted) {
        return props.formatted;
      }
      
      // Fallback: construct address from individual parts
      const addressParts = [
        props.name,
        props.street,
        props.suburb,
        props.city,
        props.state,
        props.postcode,
        props.country
      ].filter(Boolean);
      
      if (addressParts.length > 0) {
        return addressParts.join(', ');
      }
      
      // Last resort: use address_line1 or address_line2 if available
      return props.address_line1 || props.address_line2 || null;
    }
    return null;
  } catch (err) {
    console.error('Geoapify reverseGeocode error:', err.message);
    return null;
  }
}

module.exports = { reverseGeocode };
