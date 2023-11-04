import logo from './cox2.png';
import './App.css';
import React, { useEffect, useState } from 'react';
import axios from 'axios'; 
import Slider from './components/Slider';

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
      <Slider />
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        {/* <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a> */}
      </header>
    </div>
  );
}

export default App;