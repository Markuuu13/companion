const supabase = require("../db/database");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const jwtSecret = process.env.JWT_SECRET;
const refreshToken = process.env.JWT_REFRESH_TOKEN;
// For creating account
exports.register = async (req, res) => {

    console.log("Received Body:", req.body);

    try {
        const { firstname, lastname, educationLevel, selectedGrade, email, password, otp } = req.body;

        const hashedPassword = await bcrypt.hash(password, 8);

        const response = await supabase.auth.verifyOtp({
            email,
            token: otp,
            type: 'email',
        });
        // Step 2: Handle OTP verification error or success
        if (response.error) {
            console.log("Error verifying OTP:", response.error.message);
            return res.status(400).json({ message: "Invalid or expired OTP", error: response.error.message });
        }

        // creates account
        const { data, error } = await supabase.from("users").insert({
            firstname,
            lastname,
            educationLevel,
            selectedGrade,
            email,
            password: hashedPassword,
        }).select('*');

        if (error) {
            return res.status(400).json({ message: "Error occured during account creation", error: error.message });
        }

        return res.status(200).json({ data: data, message: "Account created successfully" });
    } catch (error) {
        console.error("OTP verification failed:", error);
        return res.status(500).json({ message: "Internal server error during OTP verification", error: error.message });
    }
};

exports.existingUser = async (req, res) => {
    try {

        const { email } = req.body;
        const { data: existingUser, error: errorUser } = await supabase
            .from("users")
            .select("email")
            .eq('email', email)
            .single();

        // it returns message 
        if (existingUser) {
            return res.status(409).json({ message: "This email is already registered." });
        }

        return res.status(200).json({ message: "This email is available." })
    } catch (error) {
        console.error("Error checking user: ", error);
        return res.status(500).json({ message: 'Internal Server Error, Please try again.' });
    }
}
// For Authentication

exports.login = async (req, res) => {

    try {
        const { email, password } = req.body;
        // get all the emails
        const { data, error } = await supabase
            .from('users')
            .select("user_id, *")
            .eq('email', email)
            .single();

        // check if the email is existing
        if (error || !data) {
            return res.status(400).json({ message: "User not found" });
        }

        // compare the password and the hashed password
        const passwordMatch = await bcrypt.compare(password, data.password)

        if (!passwordMatch) {
            return res.status(400).json({ message: "Incorrect Password" });
        }
        // generates JWT token
        // const token = jwt.sign(
        //     {
        //         user_id: data.user_id,
        //         email: data.email,
        //     },
        //     jwtSecret,
        //     {
        //         expiresIn: "1m"
        //     }
        // );

        // //refresh token
        // const refresh_Token = jwt.sign({
        //     user_id: data.user_id,
        // }, refreshToken, {
        //     expiresIn: "5m"
        // });

        // // store the refresh token in the database
        // const {error: refreshError} = await supabase
        //     .from('users')
        //     .update({refresh_token: refresh_Token})
        //     .eq('user_id', data.user_id);

        // if(refreshError) {
        //     console.error("Error storing refresh token:", refresh_Token.message);
        //     return res.status(500).json({messsage: "Error occured when storing the refresh token"})
        // }

        return res.status(200).json({ message: "Login successful", data });
    } catch (error) {
        res.status(500).json({ error });
        console.log(error);
    }
};

exports.registerEmailOTP = async (req, res) => {
    try {
        const { email } = req.body;

        const { data, error } = await supabase.auth.signInWithOtp({
            email,
            options: { shouldCreateUser: true, },
        });

        if (error) {
            return res.status(400).json({ message: "Error sending verification email", error: error.message });
        }

        return res.status(200).json({ message: "OTP sent to your email. Check your inbox" })
    } catch (error) {
        return res.status(500).json({ message: "Internal server error", error: error.message });
    }
}

