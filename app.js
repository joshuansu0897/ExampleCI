const express = require('express');
const app = express();

app.use(express.static(__dirname + '/public'));

// en el path principal te regresa el index
app.get('/', (req, res) => {
	return res.sendFile(__dirname + '/public/index.html');
});

// cuando vas a cualquier otro path te regresa a 'home'
app.get('/*', (req, res) => {
	return res.redirect('/');
});

module.exports = app