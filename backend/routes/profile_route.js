const router = require('express').Router();
const { profile } = require('../service/profile_service');
const { verifyToken } = require('../middleware/verify_jwt');

router.get('/profile', verifyToken, profile);

module.exports = router;