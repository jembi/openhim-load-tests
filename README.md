To deploy the services first add the hosts to the `inventory` file and then run:

```sh
ansible-playbook playbooks/deploy.yml
```

Python must be installed on the host machines before Ansible can run. On Ubuntu this can be done with:

```sh
apt update && apt install -y python
```
