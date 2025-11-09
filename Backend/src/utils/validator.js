function isValidLatLon(lat, lon) {
  const latN = Number(lat), lonN = Number(lon);
  return !Number.isNaN(latN) && !Number.isNaN(lonN) && latN >= -90 && latN <= 90 && lonN >= -180 && lonN <= 180;
}

module.exports = { isValidLatLon };
