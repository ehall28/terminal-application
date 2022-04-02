#!/bin/bash

if bundle install; then
    clear
    ruby main.rb $1 # way to pass argument to ruby from bash
else
    echo 'Please fix bundler errors and try again'
fi
