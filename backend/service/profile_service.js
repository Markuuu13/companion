const supabase = require('../db/database');
const jwt = require('jsonwebtoken');

const jwtSecret = process.env.JWT_SECRET;

exports.profile = async (req, res) => {

    try {
        const { user_id } = req.user;

        const { data, error } = await supabase
            .from('users')
            .select("*")
            .eq('user_id', user_id)
            .single();

        console.log("Supabase Response:", data);

        if (error || !data) {
            return res.status(400).json({ message: "User not found in the database" });
        }

        return res.status(200).json({ message: "Profile Fetched Successfully", profile: data })
    } catch (error) {
        res.status(500).json({ message: "Something went wrong", error: error.message });
    }
};

exports.refreshToken = async (req, res) => {
    const { refresh_token } = req.body;

    if (!refresh_token) {
        return res.status(400).json({ message: "Refresh token is required" })
    }

    try {
        const decoded = jwt.verify(refresh_token, jwtSecret);
        const userId = decoded.user_id;

        const { data, error } = await supabase
            .from('users')
            .select("refresh_token, email")
            .eq('user_id', userId)
            .single();

        if (error || !data || data.refresh_token !== refresh_token) {
            return res.status(403).json({ message: "Invalid refresh token" })
        }

        const newAccessToken = jwt.sign(
            {
                user_id: data.user_id,
                email: data.email
            },
            jwtSecret,
            {
                expiresIn: "10m"
            }
        )

        return res.status(200).json({ message: "New acces token generated", access_token: newAccessToken });
    } catch (error) {
        return res.status(401).json({ message: "Invalid refresh token" });
    }
}

exports.updateProfile = async (req, res) => {

    try {

        const { user_id, firstname, lastname, educationLevel, email } = req.body;

        const { data, error } = await supabase
            .from('users')
            .update({
                firstname: firstname,
                lastname: lastname,
                educationLevel: educationLevel,
                email: email
            })
            .eq('user_id', user_id)
            .select("*").single();

        if (error || !data) {
            return res.status(400).json({ message: "User not found in the database" });
        }
        return res.status(200).json({ message: "Profile updated successfully", data });

    } catch (error) {
        return res.status(500).json({ message: "Something went wrong", error: error.message });
    }
}