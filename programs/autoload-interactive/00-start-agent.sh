#!/bin/bash

# shellcheck disable=SC1090

SSH_ENV="$HOME/.ssh/agent-environment"
SSH_DEFAULT_TIMEOUT="1d"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >"$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" >/dev/null
    /usr/bin/ssh-add -t "$SSH_DEFAULT_TIMEOUT";
}

# Source SSH settings, if applicable

if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" >/dev/null
    #ps $SSH_AGENT_PID doesn't work under Cygwin
    if ! ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent$ >/dev/null; then
        start_agent
    fi
else
    start_agent
fi
