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

if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" >/dev/null
fi

# Probe the agent through the socket rather than parsing ps (which broke
# once the agent gained command-line args): 0 = keys loaded, 1 = alive but
# empty (expired or never added) — top up, 2 = unreachable — start fresh.
/usr/bin/ssh-add -l >/dev/null 2>&1
case $? in
    1) /usr/bin/ssh-add ;;
    2) start_agent ;;
esac
