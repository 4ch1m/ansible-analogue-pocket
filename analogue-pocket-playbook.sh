#!/bin/bash

echo '┌─────────────────────────────────────────────────────────────────────────────┐'
echo '│ ANSIBLE                                                                     │'
echo '│     _                _                        ____            _        _    │'
echo '│    / \   _ __   __ _| | ___   __ _ _   _  ___|  _ \ ___   ___| | _____| |_  │'
echo '│   / _ \ | ._ \ / _` | |/ _ \ / _` | | | |/ _ \ |_) / _ \ / __| |/ / _ \ __| │'
echo '│  / ___ \| | | | (_| | | (_) | (_| | |_| |  __/  __/ (_) | (__|   <  __/ |_  │'
echo '│ /_/   \_\_| |_|\__,_|_|\___/ \__, |\__,_|\___|_|   \___/ \___|_|\_\___|\__| │'
echo '│                              |___/                                          │'
echo '└─────────────────────────────────────────────────────────────────────────────┘'

cd "$(dirname "$(realpath "${0}")")"

python3 -m venv venv && \
source venv/bin/activate && \
pip install --upgrade --quiet ansible && \
ansible-playbook \
  --inventory "localhost," \
  "${@}" \
  analogue-pocket-playbook.yml
