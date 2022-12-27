const e = require('express');
const express = require('express');
const Document = require('../models/document');
const documentRouter = new express.Router();
const auth = require('../middlewares/auth');

documentRouter.post('/doc/create', auth, async (req, res) => {
    try{
        const {createdAt} = req.body;
        let document = new Document({
            uid: req.user,
            title: 'Untitled Document',
            createdAt,
        });

        document = await document.save();
        res.json(document);
    } catch{
        res.status(500).json({error: e.message});
    }
});

documentRouter.get('/doc/me', auth, async (req, res) => {
    try{
        const documents = await Document.find({uid: req.user});
        res.json(documents);
    } catch{
        res.status(500).json({error: e.message});
    }
});

module.exports = documentRouter;