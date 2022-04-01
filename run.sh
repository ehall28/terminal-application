#!/bin/bash

if bundle install; then
    clear
    ruby main.rb
else
    echo 'Please fix bundler errors and try again'
fi
