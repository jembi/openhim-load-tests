Python must be installed on the host machines before Ansible can run. On Ubuntu this can be done with:

```sh
apt update && apt install -y python
```

## Deploy the services

To deploy the services first add the hosts to the `inventory` file and then run:

```sh
ansible-playbook playbooks/deploy.yml
```

The MongoDB replica set will need to be initiated once the services have been deployed. This can be done by following the steps found at https://docs.mongodb.com/manual/tutorial/deploy-replica-set/#initiate-the-replica-set.
