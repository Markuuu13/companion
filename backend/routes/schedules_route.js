const router = require('express').Router();
const { addSchedule, displayScheduleToday, displaySchedules } = require('../service/schedule_service');

router.post('/addSchedule', addSchedule);
router.post('/scheduleToday', displayScheduleToday);
router.post('/getAllSchedules', displaySchedules)
module.exports = router;