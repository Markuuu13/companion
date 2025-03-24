const router = require('express').Router();
const { getGradeLevel } = require('../service/app_service');
const { getEducationLevel } = require('../service/app_service');    

router.get('/gradelevel', getGradeLevel);
router.get('/educationlevel', getEducationLevel);   

module.exports = router;