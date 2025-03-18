const supabase = require('../db/database');

exports.profile = async (req, res) => {

    try {
        const { user_id } = req.user;

        const { data, error } = await supabase
        .from('users')
        .select("user_id, email")
        .eq('user_id', user_id)
        .single();

        console.log("Supabase Response:", data);

        if (error || !data) {
            return res.status(404).json({ message: "User not found in the database" });
        }

        const userProfile = {
            user_id: data.user_id,
            email: data.email,
        }

        return res.status('200').json({ message: "Profile Fetched Successfully", profile: userProfile})
    } catch (error) {
        res.status(500).json({ message: "Something went wrong", error: error.message });
    }
};