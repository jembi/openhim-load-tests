# Openhim Performance Tests

These tests run on virtual hardware hosted on DigitalOcean and executed using Ansible playbooks.



## 1. Controller (local) machine requirements

- Install the `python` version 2.x package, if not already installed
- Install the python package manager `pip`
- Install the Digital Ocean plugin for ansible, `dopy`. Version >= 0.32
- Generate your api access token on digital ocean. Instructions on how to generate a token can be found [here](https://www.digitalocean.com/docs/api/create-personal-access-token/)
- Generate an SSH key and add it to DigitalOcean. Note the SSH key name, which can be passed in on the command line or exported as an environment variable


## 2. Provision servers

Run the ansible command in the `openhim-performance` directory, passing the api access token and the ssh key name as environment variables. 
The environment variables are named *SSH_KEY_NAME* and *DO_API_TOKEN*.

```sh
SSH_KEY_NAME=<do_ssh_key_name> DO_API_TOKEN=<api_token> ansible-playbook playbooks/create_servers.yml
```

 _Running the above command creates a new host file, and it also updates the ansible config file to point to a new host file.
 Running this command again fails as the host file will have been changed.
 To run it again successfully change the *inventory* variable value to *inventory/old._  


## 3. Initial setup for remote servers

`python` (version 2.x) and `pip` must be installed on the host machines in order for Ansible modules to run on remote targets. 
On Ubuntu this can be done with:

```sh
ansible-playbook playbooks/initial-setup.yml
```


## 4. Deploy the services

### a. Deploy Docker images to VMs

To deploy the services run:

```sh
ansible-playbook --skip-tags configuration playbooks/deploy.yml
```

### b. Manually configure MongoDB replicaset

The MongoDB replica set will need to be manually initiated once the docker images have been deployed. 
This can be done by following the steps found [here](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/#initiate-the-replica-set).
For purposes of these tests, the replicaset contains one MongoDB instance.

### c. Configure users, clients and channels in OpenHIM for performance tests

After the services have been deployed and the replica set has been initiated they can be configured with:

```sh
ansible-playbook --tags configuration playbooks/deploy.yml
```

These [instructions](https://openhim.readthedocs.io/en/latest/how-to/how-to-setup-and-configure-openhim.html#openhim-channels) detail adding a channel manually in OpenHIM using the OpenHIM Console.


## 5. Execute the tests

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
The containers logs will contain the test run output.


## 6. Collect statistics

Collect test output from Docker logs on the performance test instance

```sh
docker logs openhim-http-stress
```

```sh
docker logs openhim-http-volume
```

```sh
docker logs openhim-http-load
```

## 7. Destroy the servers

The server provisioning playbook would have produced an `inventory` file containing the ip addresses and droplet names of the
provisioned servers. This file will be used to determine which droplets need to be destroyed.

The destroy process expects the DigitalOcean API token to be assigned to the `DO_API_TOKEN` environment variable or passed on cammand line.  

```sh
DO_API_TOKEN=<api_token> ansible-playbook playbooks/do-shutdown-servers.yml
```
