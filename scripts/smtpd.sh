#!/bin/bash

echo "[run] smtpd command"
python -m smtpd -n -c DebuggingServer localhost:1025 &
