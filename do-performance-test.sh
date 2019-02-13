ansible-playbook playbooks/do-create-servers.yml
ansible-playbook -i inventory playbooks/deploy.yml
ansible-playbook playbooks/do-shutdown-servers.yml
