# Openhim Load Tests

## Server Setup
This perfomance test uses servers that are hosted on Digital Ocean. These have to be setup.

### Steps to follow
- First generate your api access token on digital ocean. Instructions on how to generate a token can be found [here](https://www.digitalocean.com/docs/api/create-personal-access-token/)
- Generate an ssh key and add it to digital ocean. Note the ssh key name (shall be passed in as an environment variable)
- Run the ansible command in the root directory, and pass the api access token and the ssh key name as environment variables. The environment variables names are *SSH_KEY_NAME* and *DO_API_TOKEN*

 example command: *SSH_KEY_NAME=<name> DO_API_TOKEN=<token> ansible-playbook ./playbooks/create_servers.yml*

 **Running the above command creates a new host file, and it also changes the ansible config file to point to a new host file**
 **Running this command again fails as the host file will have been changed. To run it again successfully change the *inventory* variable value to *inventory/old***

Python must be installed on the host machines before Ansible can run. On Ubuntu this can be done with:

```sh
apt update && apt install -y python
```

## Deploy the services

To deploy the services first setup the servers file and then run:

```sh
ansible-playbook playbooks/deploy.yml
```

The MongoDB replica set will need to be initiated once the services have been deployed. This can be done by following the steps found at https://docs.mongodb.com/manual/tutorial/deploy-replica-set/#initiate-the-replica-set.
