# Roadmap
- [x] Setup vms with constant IP 
- [x] Setup vm with authorized keys file
- [x] Run provisioner after vm setup
- [x] Install docker in turing-pi
- [x] Connect two nodes manually
- [x] Test homelab ssh key that does not use a passphrase: Solution was using a key that does not require a passpharase
- [x] Add more details to user-data
- [x] Test more user-data flow for installing k3s
- [] Add nginx support node
- [] Setup docker in nginx node
- [] Setupo linus lcs
- [] Setup nginx
- [] Setup uptime kuma
- [] Test using a additional cloud config while cloning
- [] Create multiple masters cluster
- Setup up worker module
- Setup up master module
- Create 3 masters
- Create 3 workers
- Join master to worker
- Setup ningx
- Setup postgres - done
- Setup full cluster
- [] Add docker terraform module for docker



curl -sfL https://get.k3s.io | K3S_TOKEN=775f094564997ff82fbe48901ec92e7f sh -

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.32:6443 K3S_TOKEN=775f094564997ff82fbe48901ec92e7f K3S_NODE_NAME=worker-2 sh -

