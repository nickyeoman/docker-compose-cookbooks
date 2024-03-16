# Nick Yeoman's Collection of Docker compose files

Checkout [https://www.nickyeoman.com/](https://www.nickyeoman.com/) to learn more.

The idea is to run all these services off of one host and they are setup so
you can run multiple versions of any software just by changing the .env file

The process is:

1. cd ~/Git/docker-cookbooks/app-you-want-to-use
1. cp env-sample .env
1. vi .env
  1. PREFIX in .env should the project_name (for example nick_yeoman or ny)
1. docker-compose -p project_name up -d

To create multiple projects is a little bit more tricky as you have to
define new directories for the .env file.

To do this I've just been copying the app folder to a domain-name folder.
Which isn't ideal, but I don't know how to do this more elegantly.

# Possible additions:

* mailtrain: https://hub.docker.com/r/mailtrain/mailtrain
* portus: https://hub.docker.com/r/opensuse/portus/
* silverpeas: https://hub.docker.com/_/silverpeas
