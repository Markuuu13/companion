const router = require('express').Router();
const { getGradeLevel, getEducationLevel, deleteUser, existingUsername } = require('../service/app_service');
router.get('/gradelevel', getGradeLevel);
router.get('/educationlevel', getEducationLevel);   
router.delete('/deleteUser', deleteUser);
router.post('/existingUsername', existingUsername);
module.exports = router;