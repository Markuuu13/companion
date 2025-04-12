const router = require('express').Router();
const { profile, refreshToken } = require('../service/profile_service');
const { verifyToken } = require('../middleware/verify_jwt');

router.get('/profile', verifyToken, profile);
router.post('/refresh-token', refreshToken);
module.exports = router;