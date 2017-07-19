sudo dnf -y install qemu-kvm qemu-img virt-manager libvirt iptables-service
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
