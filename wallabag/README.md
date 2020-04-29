Here is what I posted to github issues:

https://github.com/wallabag/docker/issues/153

In the hopes of saving someone else time, the Ansible script that runs is located here:
entrypoint.yml

for some reason when Ansible tries to connect to the db host, mariadb closes the connetion:
[Warning] Aborted connection 8 to db: 'unconnected' user: 'unauthenticated' host: '192.168.0.4' (This connection closed normally without authentication)

even though when you connect to the container:
docker exec -it dcebf5dcbda1 sh

you can connect to the database just fine:
mysql -h $SYMFONY__ENV__DATABASE_HOST -u root -p$MYSQL_ROOT_PASSWORD

But if I manually run the playbook:
ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local "$@"

I get the warning:
[WARNING]: Found both group and host with same name: localhost

But the playbook successfully completes.

If it doesn't (or if you have defined the mariadb user and database name in your compose file) you can try the POPULATE_DATABASE=false and then run php bin/console wallabag:install --env=prod -n from the /var/www/wallabag directory.

I think (untested) if you ran ansible-playbook -i ${HOSTNAME}, /etc/ansible/entrypoint.yml -c local "$@" instead of using an inventory and there was a check for if {{ database_name }} exists - name: add mariadb db in the playbook, it might work a little better. But I'm not sure how to stop mariadb from closing the connection.

hope this helps.
