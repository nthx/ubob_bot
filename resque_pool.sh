#!/bin/bash
export TERM_CHILD=1 
bundle exec resque-pool -c configuration/resque-pool.yml 
