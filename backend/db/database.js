require("dotenv").config();
const {createClient} = require("@supabase/supabase-js");
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_API_KEY;

if (!supabaseUrl || !supabaseKey) {
    throw new Error("Missing Supabase environment variables");
} else {
    console.log("Database Connected");
    console.log("Database is running...");
}

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;