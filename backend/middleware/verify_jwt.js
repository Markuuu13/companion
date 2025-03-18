const jwt = require('jsonwebtoken');

exports.verifyToken = async (req, res, next) => {
    const token =  req.header("Authorization")?.split(" ")[1];

    if(!token) {
        return res.status(401).json({ message: "No token provided" });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if(err) {
            return res.status(401).json({ message: "Unauthorized, invalid or expired token"});
        }
        req.user = decoded;
        next();
    });


};