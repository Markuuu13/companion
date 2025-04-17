const router = require('express').Router();
const { addSchedule } = require('../service/schedule_service');

router.post('/addSchedule', addSchedule);

module.exports = router;