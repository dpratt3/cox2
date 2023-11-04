#!/bin/bash

# Check if R is already installed and install if not
if command -v R &> /dev/null
then
    echo "R is already installed."
else
    # Update package lists and install R
    apt-get update
    apt-get install -y r-base

fi

# Seed database 
Rscript seed.R

