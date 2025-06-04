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

exports.displayScheduleToday = async (req, res) => {
    try {
        const { user_id } = req.body;

        const today = new Date().toISOString().split('T')[0];

        const { data, error } = await supabase
            .from("schedule")
            .select("*")
            .eq("user_id", user_id)
            .eq("dateScheduled", today)
            
        if(!data) {
            return res.status(404).json({message: "User not found or no schedule today"})
        }

        return res.status(200).json({message: "Date scheduled today fetch successfully", data});
    } catch (error) {
        console.error(error);
        return res.status(501).json({message: "Internal server error", error: error.message});
    }
}

exports.displaySchedules = async (req, res) => {

    try{
        const { user_id } = req.body;

        const { data, error } = await supabase
            .from("schedule")
            .select("*")
            .eq("user_id", user_id)

        if(!data) {
            return res.status(404).json({message: "User not found or no schedules created"})
        }

        return res.status(200).json({message: "Schedules fetched successfully", data});
    } catch (error) {
        console.error(error);
        return res.status(500).json({message: "Internal Server Error"});
        
    } 
}