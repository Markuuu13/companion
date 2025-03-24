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
            .order('id', {ascending: true});

        console.log(data);
            
        if (!data || error) {
            return res.status(404).json({ message: "No data found" });
        }

        return res.status(200).json({ data, message: "Data fetched successfully" })

    } catch (error) {
        return res.status(500).json({ message: "Internal server error", error: error.message });
    }
}