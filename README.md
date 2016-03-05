# Drupal Base
This docker can server as a base drupal dev container

Contains:
Nginx + Php-FPM + Drush on command line
Python3 + Python2 with supervisor are also installed

Usage:
Use supervisor to run both php-fpm and nginx.
drush can be used in a bash script or python script to sync your container with your prod/qa servers.
Suggested use along with a mariadb docker in a docker-compose file.

Use with another nginx container that can serve as a proxy to the nginx on this container


There is no entrypoint or cmd in this image. It is intended to be used within your own docker-compose files where you may run some drupal applications in a dev environment

On Docker Hub:
https://hub.docker.com/r/amalhotra/drupal_base/