// Slider.js

import React, { useState } from 'react';
import './Slider.css';

function Slider() {
  const [value, setValue] = useState(50); // Initial value for the slider

  const handleSliderChange = (event) => {
    setValue(event.target.value);
  };

  return (
    <div className="slider-container">
      <input
        type="range"
        min={0}
        max={100}
        value={value}
        onChange={handleSliderChange}
        className="slider"
      />
      <p>Value: {value}</p>
    </div>
  );
}

export default Slider;
