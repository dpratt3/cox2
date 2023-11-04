import logo from './cox2.png';
import './App.css';
import React, { useEffect, useState } from 'react';
import axios from 'axios'; 
import Slider from './components/Slider/Slider';
import StylizedHistogram from './components/Histogram/StylizedHistogram';

function App() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    // Make a GET request to the server to fetch user data
    axios.get('/getUsers')
      .then(response => {
        setUsers(response.data);
      })
      .catch(error => {
        console.error(error);
      });
  }, []);

  return (
      <div className="App">
        <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
      </header>
      <StylizedHistogram />
      <Slider />

    </div>
  );
}

export default App;