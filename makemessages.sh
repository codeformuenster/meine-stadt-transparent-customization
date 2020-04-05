#!/bin/bash

set -e

cp etc/template.env .env
/app/.venv/bin/python manage.py makemessages -l de
chown -R "$ORIGINAL_UID" /app/customization
