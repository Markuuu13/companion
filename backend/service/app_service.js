const supabase = require('../db/database');

exports.getGradeLevel = async (req, res) => {

    try {
        const { data, error } = await supabase
            .from('education_gradeLevel')
            .select('*');

        if (!data || error) {
            return res.status(404).json({ message: "No data found" });
        }

        return res.status(200).json({ data, message: "Data fetched successfully" })

    } catch (error) {
        return res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.getEducationLevel = async (req, res) => {

    try {
        const { data, error } = await supabase
            .from('education_level')
            .select('*')
            .order('id', { ascending: true });

        console.log(data);

        if (!data || error) {
            return res.status(404).json({ message: "No data found" });
        }

        return res.status(200).json({ data, message: "Data fetched successfully" })

    } catch (error) {
        return res.status(500).json({ message: "Internal server error", error: error.message });
    }
}

exports.deleteUser = async (req, res) => {

    try {
        const { user_id } = req.body;

        const { error } = await supabase
            .from('users')
            .delete()
            .eq('user_id', user_id);

        if (error) {
            return res.status(500).json({ message: "Failed to delete user", error: error.message });
        }

        return res.status(200).json({ message: "User successfully deleted" });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Internal server error", error: error.message });
    }


}

exports.existingUsername = async (req, res) => {
    try {
        const { username } = req.body;

        const { data: existingUser, error: errorUser } = await supabase
            .from("users")
            .select("username")
            .eq('username', username)
            .single();

        // it returns message 
        if (existingUser) {
            return res.status(409).json({ message: "This username is already in use.", exists: true });
        }

        return res.status(200).json({ message: "This username is available." , exists: false})
    } catch (error) {
        console.error("Error checking username: ", error);
        return res.status(500).json({ message: 'Internal Server Error, Please try again.' });
    }
}