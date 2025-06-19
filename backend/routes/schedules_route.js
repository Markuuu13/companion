const router = require('express').Router();
const { addSchedule, displayScheduleToday, displaySchedules, markAsPending, deleteTaskSchedule, autoSchedule } = require('../service/schedule_service');

router.post('/addSchedule', addSchedule);
router.post('/scheduleToday', displayScheduleToday);
router.post('/getAllSchedules', displaySchedules);
router.put('/updateScheduleStatus', markAsPending);
router.delete('/schedule/deleteSchedule', deleteTaskSchedule);

router.post('/addSchedule/autoschedule', autoSchedule);
module.exports = router;