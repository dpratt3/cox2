const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const app = express();
const port = 3001;
const { spawn } = require('child_process');

app.use(express.json());

app.post('/api/run-r-script', (req, res) => {
  const inputValue = req.body.inputValue;
  let scriptOutput = '';

  // Execute the R script with the given input value
  const classifyProcess = spawn('Rscript', ['/home/david/git/cox2classifier/scripts/classify.R', inputValue]);

  classifyProcess.stdout.on('data', (data) => {
    // console.log(`R Script Output: ${data}`);
    const outputData = data.toString();
    scriptOutput += outputData;
  });

  classifyProcess.stderr.on('data', (data) => {
    console.error(`R Script Error: ${data}`);
  });

  classifyProcess.on('close', (code) => {
    console.log(`R Script Exited with Code: ${code}`);
    // res.send('Script executed successfully');
    res.send(scriptOutput.split('\n'));
  });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

