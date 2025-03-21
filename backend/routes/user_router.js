const router = require('express').Router();
const { register, login } = require('../service/user_service');

// Register the user
router.post('/registration', register);
router.post('/login', login);

module.exports = router;