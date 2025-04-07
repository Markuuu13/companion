const router = require('express').Router();
const { register, login, registerEmailOTP, existingUser } = require('../service/user_service');

// Register the user
router.post('/registration', register);
router.post('/existingUser', existingUser);
router.post('/login', login);
router.post('/verify', registerEmailOTP);

module.exports = router;