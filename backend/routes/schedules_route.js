const router = require('express').Router();
const { addSchedule, displayScheduleToday, displaySchedules } = require('../service/schedule_service');

router.post('/addSchedule', addSchedule);
router.get('/scheduleToday', displayScheduleToday);
router.get('/getAllSchedules', displaySchedules)
module.exports = router;