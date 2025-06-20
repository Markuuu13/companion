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
        const { user_id, title, description, subject, deadlineDate, deadlineTime, priorityLevel } = req.body;

        const { data: userDetails, error: userError } = await supabase
            .from('users')
            .select("*")
            .eq("user_id", user_id)
            .single();

        if (userError || !userDetails) {
            return res.status(404).json({ message: "User not found" });
        }

        const { data: incomingSchedule, error: scheduleError } = await supabase
            .from('schedule')
            .select('dateScheduled, dateScheduledTime')
            .eq('user_id', user_id);

        if (scheduleError) {
            return res.status(500).json({ message: "Failed to fetch schedules", error: scheduleError.message });
        }

        console.log("Incoming Schedule: ", incomingSchedule);

        const currentDateTime = new Date().toLocaleString('en-US', { timeZone: 'Asia/Manila' });

        const prompt = `
        Hi AI assistant that schedule tasks. 
        I am ${userDetails.educationLevel} ${userDetails.selectedGrade} student. I want to avoid cramming and want to be organized with my tasks.
        
        Can you create a schedule for this task?
        Task Title: ${title}
        The task is all about or the description of the task is: ${description}
        Subject: ${subject}
        Deadline: ${deadlineDate} at ${deadlineTime}
        Priority: ${priorityLevel}

        Interpret priority as follows:
        - High Priority: Schedule this task as early as possible, preferably within the next 1–2 days.
        - Medium Priority: Schedule within a few days, but before the deadline.
        - Low Priority: Can be scheduled flexibly as long as it doesn’t conflict with other tasks and is before the deadline.
        
        Avoid conflicts with those existing schedule: ${JSON.stringify(incomingSchedule)}

        Suggest the best time and date to do this task before the deadline. Rely on the priority level and what is task all about. Also the user is a ${userDetails.educationLevel} ${userDetails.selectedGrade} student so consider the time of the day that is best for studying and doing tasks. 
        Respond in this exact JSON format:
        Make sure the suggested time is in the future — it must be later than the current time now: ${currentDateTime}.
        {
            "dateScheduled": "YYYY-MM-DD",
            "dateScheduledTime": "HH:MM:SS",
            "message": "Provide a short, professional, and encouraging tip to help the user succeed in the ${title} that have a description of ${description}. The tone should be supportive, motivational, and appropriate for a student. Avoid generic phrases—give practical advice or a helpful mindset reminder."
        }
        `;

        const model = genAI.getGenerativeModel({ model: "models/gemini-1.5-flash" })
        const result = await model.generateContent(prompt);
        const text = result.response.text();

        const jsonStart = text.indexOf('{');
        const jsonEnd = text.lastIndexOf('}') + 1;
        const jsonResponse = JSON.parse(text.substring(jsonStart, jsonEnd));

        res.status(200).json(jsonResponse);
    } catch (error) {
        console.error("Gemini error: ", error.message);
        return res.status(500).json({ message: error.message });
    }
}