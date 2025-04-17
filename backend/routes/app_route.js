const router = require('express').Router();
const { getGradeLevel, getEducationLevel, deleteUser } = require('../service/app_service');
router.get('/gradelevel', getGradeLevel);
router.get('/educationlevel', getEducationLevel);   
router.delete('/deleteUser', deleteUser);

module.exports = router;