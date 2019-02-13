# Openhim Load Tests


## Server Setup
This perfomance test uses servers that are hosted on Digital Ocean. These have to be setup.

### Steps to follow
- First generate your api access token on digital ocean. Instructions on how to generate token can be found on [here](https://www.digitalocean.com/docs/api/create-personal-access-token/)
- Generate an ssh key and add it to digital ocean. Note the ssh key name (shall be passed in as an environment variable)
- Run the ansible command in the root directory, and pass the api access token and the ssh key name as environment variables. The environment variables names are *SSH_KEY_NAME* and *DO_API_TOKEN*

example command: *SSH_KEY_NAME=<name> DO_API_TOKEN=<token> ansible ./playbooks/create_servers.yml*
