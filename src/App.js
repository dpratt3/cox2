import logo from './logo.svg';
import './App.css';
import React, { useEffect, useState } from 'react';
import axios from 'axios'; // You'll need to install Axios


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
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;


// cox2Class (cox2)        COX-2 Activity Data
// cox2Descr (cox2)        COX-2 Activity Data
// cox2IC50 (cox2)         COX-2 Activity Data