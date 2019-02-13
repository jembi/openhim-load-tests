INVNAME=`pwd`/new_inventory.ini

rm -f $INVNAME

ansible-playbook --extra-vars "new_inventory=$INVNAME" playbooks/do-create-servers.yml

if [[ ! -f "$INVNAME" ]]; then
  echo "Error: No inventory file at $INVNAME after droplets created"
  exit 1
fi

ansible-playbook -i $INVNAME playbooks/initial.yml
ansible-playbook -i $INVNAME playbooks/deploy.yml
ansible-playbook -i $INVNAME playbooks/do-shutdown-servers.yml
