#!/bin/bash
export TERM_CHILD=1 
mkdir -p log
bundle exec resque-pool -c configuration/resque-pool.yml -d -o log/resque_pool_stdout.log -e log/resque_pool_stderr.log

#resque-pool is the best way to manage a group (pool) of resque workers
#
#When daemonized, stdout and stderr default to resque-pool.stdxxx.log files in
#the log directory and pidfile defaults to resque-pool.pid in the current dir.
#
#Usage:
#   resque-pool [options]
#where [options] are:
#       --config, -c <s>:   Alternate path to config file
#      --appname, -a <s>:   Alternate appname
#           --daemon, -d:   Run as a background daemon
#       --stdout, -o <s>:   Redirect stdout to logfile
#       --stderr, -e <s>:   Redirect stderr to logfile
#           --nosync, -n:   Don't sync logfiles on every write
#      --pidfile, -p <s>:   PID file location
#  --environment, -E <s>:   Set RAILS_ENV/RACK_ENV/RESQUE_ENV
#          --version, -v:   Print version and exit
#             --help, -h:   Show this message
