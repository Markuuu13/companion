const router = require('express').Router();
const { addSchedule, displayScheduleToday, displaySchedules, markAsPending, deleteTaskSchedule } = require('../service/schedule_service');

router.post('/addSchedule', addSchedule);
router.post('/scheduleToday', displayScheduleToday);
router.post('/getAllSchedules', displaySchedules);
router.put('/updateScheduleStatus', markAsPending);
router.delete('/schedule/deleteSchedule', deleteTaskSchedule);
module.exports = router;