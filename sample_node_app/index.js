const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.send('This is Sample Node JS app for Paytm Insider');
});

app.listen(3000, () => {
  console.log('Listening on port 3000');
});
