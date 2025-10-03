# Download cloud image
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

# Import cloud image
qm create 9000 --name debian12-cloudinit


# Once image is created 
qm set 9000 --scsi0 local-lvm:0,import-from=/root/debian-12-genericcloud-amd64.qcow2


# Create template
qm template 9000


# Create snippet to import cloud image
mkdir /var/lib/vz/snippets
tee /var/lib/vz/snippets/qemu-guest-agent.yml <<EOF
#cloud-config
runcmd:
  - apt update
  - apt install -y qemu-guest-agent
  - systemctl start qemu-guest-agent
EOF

# openssl passwd -6 "your_password_here"

# pvesm set local --content iso,vztmpl,backup,import,snippets

# pvesm status