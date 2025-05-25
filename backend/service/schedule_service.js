const supabase = require('../db/database');

exports.addSchedule = async (req, res) => {

    try {
        const { user_id, title, description, subject, deadlineDate, deadlineTime, dateScheduled, dateScheduledTime} = req.body;

        const { data, error } = await supabase
            .from('schedule')
            .insert({
                user_id,
                title,
                description,
                subject,
                deadlineDate,
                deadlineTime,
                dateScheduled,
                dateScheduledTime,
            }).select("*");

        if (error) {
            console.error(error);
            return res.status(500).json({ message: "Failed to add schedule", error: error.message });
        }

        return res.status(200).json({ message: "Schedule added successfully", schedule: data });
    } catch (error) {
        console.error(error);
        return res.status(501).json({ message: "Internal server error", error: error.message });

    }
}