import React from 'react';
import './ClassifyButton.css'; 
import axios from 'axios';
import { useState } from 'react';

const ClassifyButton = () => {
  const [output, setOutput] = useState('');
  
  const handleClassifyClick = () => {
    const inputValue = 25; // Hard code for now
    
    axios.post('/api/run-r-script', { inputValue })
      .then(response => {
        const scriptOutput = response.data;
        setOutput(scriptOutput) 
      })
      .catch(error => {
        console.error(error); 
      });
  };
    return (
      <div>
        <button className="classify-button" onClick={handleClassifyClick}>Classify</button>
        <div style={{ color: 'white' }} id="output" className="output">{output}</div>
      </div>
  );
};

export default ClassifyButton;
