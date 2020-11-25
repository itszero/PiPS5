#!/bin/sh
rsync --exclude node_modules --exclude .git --exclude test_data -avP . pi@pips5.local:/pips5/
ssh pi@pips5.local "sudo cp /pips5/pi/supervisord.conf /etc/supervisor/conf.d/pips5.conf"
ssh pi@pips5.local "sudo cp /pips5/pi/nginx.conf /etc/nginx/sites-available/default"
ssh pi@pips5.local "sudo supervisorctl reread; sudo supervisorctl update; sudo systemctl reload nginx"

