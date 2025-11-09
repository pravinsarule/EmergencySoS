// const { Pool } = require('pg');
// require('dotenv').config();

// const pool = new Pool({
//   connectionString: process.env.DATABASE_URL,
//   // ssl: { rejectUnauthorized: false } // uncomment for production with SSL
// });

// pool.on('error', (err) => {
//   console.error('Unexpected PG error', err);
// });

// module.exports = { pool };
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false } // Uncomment for production with SSL
});

// ✅ Check for unexpected errors
pool.on('error', (err) => {
  console.error('Unexpected PG error', err);
});

// ✅ Test connection and log success
(async () => {
  try {
    const client = await pool.connect();
    console.log('✅ PostgreSQL Database Connected Successfully!');
    client.release();
  } catch (err) {
    console.error('❌ Error connecting to PostgreSQL:', err.message);
  }
})();

module.exports = { pool };
