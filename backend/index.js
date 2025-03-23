const app = require("./app");
const userRouter = require("./routes/user_router");
const profileRouter = require("./routes/profile_route");
const appServiceRouter = require("./routes/app_route");

const PORT = 3500;

app.use(userRouter);
app.use(profileRouter);
app.use(appServiceRouter);

app.listen(PORT,"0.0.0.0", () => {
    console.log("Server connected at Port:", PORT);
    
})


