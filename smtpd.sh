#!/bin/bash

echo "[run] smptpd command"
python -m smtpd -n -c DebuggingServer localhost:1025 &
