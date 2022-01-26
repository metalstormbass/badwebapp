#!/bin/bash
gunicorn --bind=0.0.0.0:8000 --chdir=/home/badwebuser/VulnerableWebApp/VulnerableWebApp/ VulnerableWebApp.wsgi  --user badwebuser  --workers 3 & nginx -g "daemon off;"
