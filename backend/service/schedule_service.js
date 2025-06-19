const supabase = require('../db/database');
const openai = require('../middleware/openai');
const genAI = require('../middleware/gemini');
// Add Schedule
exports.addSchedule = async (req, res) => {

    try {
        const { user_id, title, description, subject, deadlineDate, deadlineTime, dateScheduled, dateScheduledTime, preferColor } = req.body;

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
                preferColor,
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

        // const today = new Date().toISOString().split('T')[0];
        const today = new Date().toLocaleDateString('en-CA');
        const { data, error } = await supabase
            .from("schedule")
            .select("schedule_id, *")
            .eq("user_id", user_id)
            .eq("dateScheduled", today)

        if (error) {
            return res.status(500).json({ message: "Error fetching schedule", error: error.message });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({ message: "No schedule for today" });
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

        if (!data) {
            return res.status(404).json({ message: "Schedule not found?" });
        }
        if (error) {
            return res.status(500).json({ message: "Error occured. Please try again." });
        }

        return res.status(200).json({ message: "Task schedule deleted successfully!" });
    } catch (error) {
        console.error(error.message);
        return res.status(500).json({ message: "Internal server error!" });

    }
}

// OPENAI
// exports.autoSchedule = async (req, res) => {
//     try {
//         const { title, deadlineDate, deadlineTime, priorityLevel, existingSchedule } = req.body;

//         const prompt = `
//         You are an AI assistant that schedule tasks. A user has this task:
//         Task: ${title}
//         Deadline: ${deadlineDate} at ${deadlineTime}
//         Priority: ${priorityLevel}
//         Existing schedule: ${JSON.stringify(existingSchedule)}

//         Suggest the best time and date to do this task before the deadline. Respond in this exact JSON format:
//         {
//             "suggestedDate": "MM-DD-YYYY",
//             "suggestedTime": "HH:MM AM/PM"
//         }
//         `;

//         const response = await openai.chat.completions.create({
//             model: 'gpt-3.5-turbo',
//             messages: [{ role: 'user', content: prompt }],
//             temperature: 0.7,
//         });

//         const aiReply = response.choices[0].message.content;
//         const suggestion = JSON.parse(aiReply);

//         res.json(suggestion);
//     } catch (error) {
//         console.error("OpenAI error: ", error.message);
//         return res.status(500).json({ message: error.message });
//     }
// }

// GEMINI
exports.autoSchedule = async (req, res) => {
    try {
        const { title, deadlineDate, deadlineTime, priorityLevel, existingSchedule } = req.body;

        const prompt = `
        You are an AI assistant that schedule tasks. A user has this task:
        Task: ${title}
        Deadline: ${deadlineDate} at ${deadlineTime}
        Priority: ${priorityLevel}
        Existing schedule: ${JSON.stringify(existingSchedule)}

        Suggest the best time and date to do this task before the deadline. Respond in this exact JSON format:
        {
            "suggestedDate": "MM-DD-YYYY",
            "suggestedTime": "HH:MM AM/PM"
        }
        `;

        const model = genAI.getGenerativeModel({ model: "gemini-pro" })
        const result = await model.generateContent(prompt);
        const text = result.response.text();

        const jsonStart = text.indexOf('{');
        const jsonEnd = text.lastIndexOf('}') + 1;
        const jsonResponse = JSON.parse(text.substring(jsonStart, jsonEnd));

        res.json(jsonResponse);
    } catch (error) {
        console.error("Gemini error: ", error.message);
        return res.status(500).json({ message: error.message });
    }
}