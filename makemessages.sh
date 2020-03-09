#!/bin/bash

set -e

cp etc/template.env .env
/app/.venv/bin/python manage.py makemessages -v 2 -a --keep-pot -l de
