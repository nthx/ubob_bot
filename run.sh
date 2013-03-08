#!/bin/bash

if [ -e configuration/settings.rb ];
then
  echo "Configuration found, running ubob bot"
  ruby app.rb 2>&1
else
  echo "No configuration found! adjust & cp configuration/settings.rb.example -> configuration/settings.rb"
fi
