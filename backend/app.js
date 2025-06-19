const express = require("express");
const app = express();
require("dotenv").config();
const cors = require('cors');

app.use(express.json());
app.use(cors());
module.exports = app;