const axios = require('axios');
require('dotenv').config();

const getWeatherByCity = async (ville) => {
  const apiKey = process.env.WEATHER_API_KEY;
  const url = `https://api.openweathermap.org/data/2.5/weather?q=${ville}&lang=ar&appid=${apiKey}&units=metric`;

  const response = await axios.get(url);
  return response.data;
};

module.exports = { getWeatherByCity };
