import logo from './cox2.png';
import './App.css';
// import React, { useEffect, useState } from 'react';
// import axios from 'axios'; 
import Slider from './components/Slider/Slider';
import StylizedHistogram from './components/Histogram/StylizedHistogram';
import ClassifyButton from './components/Buttons/ClassifyButton'; // Import the ClassifyButton component


function App() {

  return (
      <div className="App">
        <h1 style={{ color: 'white', fontSize: '36px'}}>Cycloxygenase Two Classifier</h1>
        <div className="translucent">
          <StylizedHistogram />
          <Slider />
        </div>
      <ClassifyButton /> 
      <img src={logo} className="App-logo" alt="logo" />
    </div>
  );
}


export default App;