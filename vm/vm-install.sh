sudo dnf -y install qemu-kvm qemu-img virt-manager libvirt
if [ ! -r /etc/polkit-1/rules.d/56-libvirt.rules ] ; then
  cp 56-libvirt.rules /etc/polkit-1/rules.d
fi
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

