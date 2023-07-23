#!/bin/sh

# ssh directly to a tmux session on the server

TERM=xterm-256color ssh -t "$@" -- 'tmux has-session && exec tmux attach || exec tmux'

