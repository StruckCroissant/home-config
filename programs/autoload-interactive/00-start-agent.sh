#!/bin/bash

# shellcheck disable=SC1090

SSH_ENV="$HOME/.ssh/agent-environment"
# Pinned socket path so the agent can be reached from bind mounts
# (e.g. dev containers mounting ~/.ssh); ssh-agent's default random
# /tmp path can't be mounted stably.
SSH_AGENT_SOCK="$HOME/.ssh/agent.sock"
SSH_DEFAULT_TIMEOUT="1d"

function start_agent {
    echo "Initialising new SSH agent..."
    # A stale socket file from a dead agent blocks -a.
    rm -f "$SSH_AGENT_SOCK"
    # -t on the agent (not ssh-add) makes the lifetime apply to every key
    # added later too, including re-adds via AddKeysToAgent.
    /usr/bin/ssh-agent -t "$SSH_DEFAULT_TIMEOUT" -a "$SSH_AGENT_SOCK" | sed 's/^echo/#echo/' >"$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" >/dev/null
    /usr/bin/ssh-add
}

# Source SSH settings, if applicable

if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" >/dev/null
    #ps $SSH_AGENT_PID doesn't work under Cygwin
    if ! ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent$ >/dev/null; then
        start_agent
    elif ! /usr/bin/ssh-add -l >/dev/null 2>&1; then
        # Agent alive but keys expired (-t above) — top up so shells and
        # anything sharing the socket get working auth again.
        /usr/bin/ssh-add
    fi
else
    start_agent
fi
