const supabase = require("../db/database");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const jwtSecret = process.env.JWT_SECRET;
// For creating account
exports.register = async (req, res) => {
    
    console.log("Received Body:", req.body); 

    try {
        const {email, password} = req.body;

        const hashedPassword = await bcrypt.hash(password, 8);

        // if the user is already existing, don't create an account
        const{data: existingUser, error: errorUser} = await supabase
        .from("users")
        .select("email")
        .eq('email', email)
        .single();
        
        // it returns message 
        if(existingUser) {
            return res.status(500).json({message: "This email is already registered"});
        }

        // creates account
        const {data, error} = await supabase.from("users").insert({
            email,
            password: hashedPassword,
        }).select('*');

        if(error) {
            return res.status(404).json({message: "no data", error: error.message});
        }

        return res.status(200).json({data: data, message: "Account created successfully"});
    } catch (error) {
        res.status(404).json({error});
        console.log(error);
    }
};

// For Authentication

exports.login = async (req, res) => {

    try {
        const {email, password} = req.body;
        // get all the emails
        const {data, error} = await supabase
        .from('users')
        .select("user_id, email, password")
        .eq('email', email)
        .single();

        // check if the email is existing
        if (error || !data) {
            return res.status(404).json({ message: "User not found" });
        }

        // compare the password and the hashed password
        const passwordMatch = await bcrypt.compare(password, data.password)

        if(!passwordMatch) {
            return res.status(401).json({message: "Incorrect Password"});
        }
        // generates JWT token
        const token = jwt.sign(
            {
                user_id: data.user_id, 
                email: data.email,
            },
            jwtSecret,
            {
                expiresIn: "1m"
            }
        );
        return res.status(200).json({ message: "Login successful", token});
    } catch (error) {
        res.status(404).json({error});
        console.log(error);
    }
};