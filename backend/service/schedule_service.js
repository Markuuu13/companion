const supabase = require('../db/database');

// Add Schedule
exports.addSchedule = async (req, res) => {

    try {
        const { user_id, title, description, subject, deadlineDate, deadlineTime, dateScheduled, dateScheduledTime } = req.body;

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

// Delete
exports.deleteTask = async (req, res) => {

}

// Edit 
exports.editTasks = async (req, res) => {

}

// Update to "Pending"
exports.markAsPending = async (req, res) => {

    try {
        const { user_id, status_id, schedule_id } = req.body;

        const { data, error } = await supabase
            .from('schedule')
            .update({ status_id })
            .eq("schedule_id", schedule_id)
            .select();

        if (error) {
            console.error(error);
            return res.status(500).json({ message: "Database error", details: error.message });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({ message: "Schedule not found" });
        }

        return res.status(200).json({ message: "The schedule status has been changed", data });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Error occured!" });

    }
}

// Update to "Completed"
exports.markAsCompleted = async (req, res) => {

}

// Today Schedule
exports.displayScheduleToday = async (req, res) => {
    try {
        const { user_id } = req.body;

        const today = new Date().toISOString().split('T')[0];

        const { data, error } = await supabase
            .from("schedule")
            .select("schedule_id, *")
            .eq("user_id", user_id)
            .eq("dateScheduled", today)

        if (!data) {
            return res.status(404).json({ message: "User not found or no schedule today" })
        }

        return res.status(200).json({ message: "Date scheduled today fetch successfully", data });
    } catch (error) {
        console.error(error);
        return res.status(501).json({ message: "Internal server error", error: error.message });
    }
}

// Overall Schedules
exports.displaySchedules = async (req, res) => {

    try {
        const { user_id } = req.body;

        const { data, error } = await supabase
            .from("schedule")
            .select("schedule_id, *")
            .eq("user_id", user_id)

        if (!data) {
            return res.status(404).json({ message: "User not found or no schedules created" })
        }

        return res.status(200).json({ message: "Schedules fetched successfully", data });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Internal Server Error" });

    }
}

exports.deleteTaskSchedule = async (req, res) => {
    try {
        const { schedule_id } = req.body;

        const { data, error } = await supabase
            .from('schedule')
            .delete()
            .eq('schedule_id', schedule_id)
            .single();

        if(!data) {
            return res.status(404).json({ message: "Schedule not found?"});
        }
        if(error) {
            return res.status(500).json({ message: "Error occured. Please try again."});
        }

        return res.status(200).json({ message: "Task schedule deleted successfully!"});
    } catch (error) {
        console.error(error.message);
        return res.status(500).json({ message: "Internal server error!"});
        
    }
}