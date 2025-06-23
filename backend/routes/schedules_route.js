const router = require('express').Router();
const { addSchedule, displayScheduleToday, incomingSchedule, markAsPending, deleteTaskSchedule, deleteMultipleTasks, autoSchedule } = require('../service/schedule_service');

router.post('/addSchedule', addSchedule);
router.post('/schedule/scheduleToday', displayScheduleToday);
router.get('/schedule/incomingSchedules', incomingSchedule);
router.put('/updateScheduleStatus', markAsPending);
router.delete('/schedule/deleteSchedule', deleteTaskSchedule);
router.delete('/schedule/deleteMultiple', deleteMultipleTasks);
router.post('/addSchedule/autoschedule', autoSchedule);
module.exports = router;