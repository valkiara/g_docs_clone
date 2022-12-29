const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const http = require('http');
const authRouter = require('./routes/auth');
const documentRouter = require('./routes/document');
const Document = require("./models/document")

const PORT = process.env.PORT | 3001;
const DB = "mongodb+srv://sa:SAPB1Admin@cluster0.4nosaow.mongodb.net/?retryWrites=true&w=majority";

const app = express();
var server = http.createServer(app);
var io = require('socket.io')(server);

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

mongoose.connect(DB).then(() => {
    console.log("connected to database");
}).catch((err) => {
    console.log(err);
});

io.on('connection', (socket) => {
    socket.on('join', (documentId) => {
        socket.join(documentId);
    });

    socket.on('typing', (data) => {
        socket.broadcast.to(data.room).emit('changes', data);
    });

    socket.on('save', (data) => {
        saveData(data);
    });
});

const saveData = async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
  };

server.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`)
});