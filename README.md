Python must be installed on the host machines before Ansible can run. On Ubuntu this can be done with:

```sh
apt update && apt install -y python
```

## Deploy the services

To deploy the services first add the hosts to the `inventory` file and then run:

```sh
ansible-playbook --skip-tags configure playbooks/deploy.yml
```

The MongoDB replica set will need to be initiated once the services have been deployed. This can be done by following the steps found at https://docs.mongodb.com/manual/tutorial/deploy-replica-set/#initiate-the-replica-set.

## Configure the services

After the services have been deployed and the replica set has been initiated they can be configured with:

```sh
ansible-playbook --tags configure playbooks/deploy.yml
```

## Execute the tests

The tests can be executed by running one of:

```sh
ansible-playbook playbooks/execute_http_load_test.yml
```

```sh
ansible-playbook playbooks/execute_http_stress_test.yml
```

```sh
ansible-playbook playbooks/execute_http_volume_test.yml
```

Each of these playbooks will start the specified test as a detached process in a Docker container. The results can be seen by looking at the logs of the containers at this point.
