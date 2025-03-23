const router = require('express').Router();
const { getEducationLevel } = require('../service/app_service');

router.get('/educationlevel', getEducationLevel);

module.exports = router;