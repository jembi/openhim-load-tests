# Openhim Load Tests

These performance tests use virtual hardware hosted on DigitalOcean.
 


## 1. Controller (local) machine requirements

- Install the python package manager, 'pip'
- Install the Digital Ocean plugin for ansible, 'dopy'. Version >= 0.32
- Generate your api access token on digital ocean. Instructions on how to generate a token can be found [here](https://www.digitalocean.com/docs/api/create-personal-access-token/)
- Generate an ssh key and add it to digital ocean. Note the ssh key name (shall be passed in as an environment variable)


## 2. Provision servers

Run the ansible command in the root directory, and pass the api access token and the ssh key name as environment variables. 
The environment variables names are *SSH_KEY_NAME* and *DO_API_TOKEN*

```sh
SSH_KEY_NAME=<do_ssh_key_name> DO_API_TOKEN=<api_token> ansible-playbook playbooks/create_servers.yml
```

 *Running the above command creates a new host file, and it also changes the ansible config file to point to a new host file.
 Running this command again fails as the host file will have been changed.
 To run it again successfully change the *inventory* variable value to *inventory/old.*  


## 3. Initial setup for remote servers

`python` and `pip` must be installed on the host machines in order for Ansible modules to run on remote targets. 
On Ubuntu this can be done with:

```sh
ansible-playbook playbooks/initial-setup.yml
```


## 4. Deploy the services

To deploy the services first setup the servers file and then run:

```sh
ansible-playbook --skip-tags configure playbooks/deploy.yml
```

The MongoDB replica set will need to be initiated once the services have been deployed. 
This can be done by following the steps found at https://docs.mongodb.com/manual/tutorial/deploy-replica-set/#initiate-the-replica-set.


## 5. Configure the services

After the services have been deployed and the replica set has been initiated they can be configured with:

```sh
ansible-playbook --tags configure playbooks/deploy.yml
```


## 6. Execute the tests

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

Each of these playbooks will start the specified test as a detached process in a Docker container. 
The results can be seen by looking at the logs of the containers at this point.


## 7. Destroying the servers

The server provisioning playbook would have produced an `inventory` file containing the ip addresses and droplet names of the
provisioned servers. This file will be used to determine which droplets need to be destroyed.

The destroy process expects the DigitalOcean API token to be assigned to the `DO_API_TOKEN` environment variable.  

```sh
ansible-playbook playbooks/do-shutdown-servers.yml
```
