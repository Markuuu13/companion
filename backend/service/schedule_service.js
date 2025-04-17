const supabase = require('../db/database');

exports.addSchedule = async (req, res) => {

    try {
        const { user_id, title, description, } = req.body;

        const { data, error } = await supabase
            .from('schedules')
            .insert({
                user_id,
                title,
                description
            })

        if (error) {
            console.error(error);
            return res.status(500).json({ message: "Failed to add schedule", error: error.message });
        }

        return res.status(200).json({ message: "Schedule added successfully", schedule: data });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Internal server error", error: error.message });

    }
}