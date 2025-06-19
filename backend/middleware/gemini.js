const { GoogleGenerativeAI } = require('@google/generative-ai');
require("dotenv").config();

const genAI = new GoogleGenerativeAI(process.env.GEMINIAPI_KEY);

module.exports = genAI;