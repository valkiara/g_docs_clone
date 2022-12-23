const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRouter = require('./routes/auth');

const PORT = process.env.PORT | 3001;
const DB = "mongodb+srv://sa:SAPB1Admin@cluster0.4nosaow.mongodb.net/?retryWrites=true&w=majority";

const app = express();

app.use(cors());
app.use(express.json());
app.use(authRouter);

mongoose.connect(DB).then(() => {
    console.log("connected to database");
}).catch((err) => {
    console.log(err);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`)
});